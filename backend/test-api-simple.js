#!/usr/bin/env node
/**
 * GERAK Backend API Testing - Simplified Version
 */

const baseUrl = 'http://localhost:5000';
let results = [];

async function test(name, fn) {
  try {
    await fn();
    console.log(`✓ ${name}`);
    results.push({ name, status: 'pass' });
  } catch (err) {
    console.log(`✗ ${name}: ${err.message}`);
    results.push({ name, status: 'fail' });
  }
}

async function request(method, path, body = null, headers = {}) {
  const url = `${baseUrl}${path}`;
  const opts = {
    method,
    headers: { 
      'Content-Type': 'application/json',
      ...headers,
    },
  };
  if (body) opts.body = JSON.stringify(body);

  const res = await fetch(url, opts);
  const data = await res.json();
  return { status: res.status, data };
}

(async () => {
  console.log('\n╔════════════════════════════════════════════════════╗');
  console.log('║   GERAK Backend Comprehensive API Test              ║');
  console.log('╚════════════════════════════════════════════════════╝\n');

  let tokens = {};

  // ===== AUTHENTICATION =====
  console.log('📝 AUTHENTICATION\n');

  await test('1. Register User 1 (Adi)', async () => {
    const res = await request('POST', '/auth/register', {
      email: 'adi@gerak.test',
      password: 'SecurePass123',
      name: 'Adi Wijaya',
      phone: '+6281234567890',
      sports: ['futsal', 'badminton'],
      level: 'intermediate',
    });
    if (res.status !== 201) throw new Error(`Got ${res.status}, expected 201`);
    tokens.adi = res.data.token;
    console.log('   → User created, token saved');
  });

  await test('2. Register User 2 (Budi - Organizer)', async () => {
    const res = await request('POST', '/auth/register', {
      email: 'budi@gerak.test',
      password: 'SecurePass456',
      name: 'Budi Santoso',
      phone: '+6287654321098',
      sports: ['futsal'],
      level: 'advanced',
    });
    if (res.status !== 201) throw new Error(`Got ${res.status}, expected 201`);
    tokens.budi = res.data.token;
  });

  await test('3. Reject duplicate email', async () => {
    const res = await request('POST', '/auth/register', {
      email: 'adi@gerak.test',
      password: 'AnotherPass123',
      name: 'Someone Else',
      phone: '+6289876543210',
      sports: ['tennis'],
      level: 'beginner',
    });
    if (res.status === 201) throw new Error('Should reject duplicate email');
    if (res.status !== 400) throw new Error(`Expected 400, got ${res.status}`);
  });

  await test('4. Login with correct credentials', async () => {
    const res = await request('POST', '/auth/login', {
      email: 'adi@gerak.test',
      password: 'SecurePass123',
    });
    if (res.status !== 200) throw new Error(`Got ${res.status}, expected 200`);
    if (!res.data.token) throw new Error('No token in response');
  });

  await test('5. Reject wrong password', async () => {
    const res = await request('POST', '/auth/login', {
      email: 'adi@gerak.test',
      password: 'WrongPassword',
    });
    if (res.status === 200) throw new Error('Should reject wrong password');
  });

  // ===== EVENTS =====
  console.log('\n📅 EVENTS (Regional Filtering)\n');

  let event1Id, event2Id;

  await test('1. Create Event (Futsal - Jakarta)', async () => {
    const res = await request('POST', '/events', {
      name: 'Futsal Malam - Menteng',
      description: 'Main futsal santai Kamis malam',
      sport: 'futsal',
      level: 'beginner',
      startTime: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000).toISOString(),
      endTime: new Date(Date.now() + 2 * 24 * 60 * 60 * 1000 + 2 * 60 * 60 * 1000).toISOString(),
      location: 'Lapangan Futsal Senayan',
      city: 'Jakarta',
      district: 'Menteng',
      maxSlots: 10,
      totalSlots: 10,
      adminPhone: '+6287654321098',
    }, {
      'Authorization': `Bearer ${tokens.budi}`,
    });
    if (res.status !== 201) throw new Error(`Got ${res.status}, expected 201`);
    event1Id = res.data.event._id;
    console.log(`   → Event created: ${res.data.event.name}`);
    console.log(`   → City: ${res.data.event.city}, District: ${res.data.event.district}`);
  });

  await test('2. Create Event (Badminton - Bandung)', async () => {
    const res = await request('POST', '/events', {
      name: 'Badminton Kompetitif',
      description: 'Pertandingan level intermediate',
      sport: 'badminton',
      level: 'intermediate',
      startTime: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000).toISOString(),
      endTime: new Date(Date.now() + 3 * 24 * 60 * 60 * 1000 + 3 * 60 * 60 * 1000).toISOString(),
      location: 'GOR Bandung Utara',
      city: 'Bandung',
      district: 'Cibeunying',
      maxSlots: 8,
      totalSlots: 8,
      adminPhone: '+6287654321098',
    }, {
      'Authorization': `Bearer ${tokens.budi}`,
    });
    if (res.status !== 201) throw new Error(`Got ${res.status}, expected 201`);
    event2Id = res.data.event._id;
    console.log(`   → City: ${res.data.event.city}, District: ${res.data.event.district}`);
  });

  await test('3. List all events', async () => {
    const res = await request('GET', '/events');
    if (res.status !== 200) throw new Error(`Got ${res.status}`);
    if (!Array.isArray(res.data.events)) throw new Error('No events array');
    console.log(`   → Total events: ${res.data.total}`);
  });

  await test('4. Filter by city (Jakarta)', async () => {
    const res = await request('GET', '/events?city=Jakarta');
    if (res.status !== 200) throw new Error(`Got ${res.status}`);
    const jakarta = res.data.events.filter(e => e.city.toLowerCase().includes('jakarta'));
    if (jakarta.length === 0) throw new Error('No Jakarta events found');
    console.log(`   → Found ${jakarta.length} event(s) in Jakarta`);
  });

  await test('5. Filter by city + district', async () => {
    const res = await request('GET', '/events?city=Jakarta&district=Menteng');
    if (res.status !== 200) throw new Error(`Got ${res.status}`);
    const filtered = res.data.events.filter(e => 
      e.city.toLowerCase().includes('jakarta') && 
      e.district.toLowerCase().includes('menteng')
    );
    if (filtered.length === 0) throw new Error('No Jakarta+Menteng events found');
    console.log(`   → Found ${filtered.length} event(s) in Jakarta, Menteng`);
  });

  await test('6. Filter by sport (futsal)', async () => {
    const res = await request('GET', '/events?sport=futsal');
    if (res.status !== 200) throw new Error(`Got ${res.status}`);
    const futsal = res.data.events.filter(e => e.sport.toLowerCase() === 'futsal');
    if (futsal.length === 0) throw new Error('No futsal events found');
    console.log(`   → Found ${futsal.length} futsal event(s)`);
  });

  await test('7. Get event by ID', async () => {
    if (!event1Id) throw new Error('No event ID');
    const res = await request('GET', `/events/${event1Id}`);
    if (res.status !== 200) throw new Error(`Got ${res.status}`);
    console.log(`   → ${res.data.event.name}`);
  });

  // ===== JOIN / PARTICIPANTS =====
  console.log('\n👥 PARTICIPATION\n');

  await test('1. Join event', async () => {
    if (!event1Id) throw new Error('No event ID');
    const res = await request('POST', `/events/${event1Id}/join`, {}, {
      'Authorization': `Bearer ${tokens.adi}`,
    });
    if (res.status !== 200) throw new Error(`Got ${res.status}`);
    const joined = res.data.event.joinedUsers.length;
    console.log(`   → Joined! Current participants: ${joined}`);
  });

  await test('2. Prevent duplicate join', async () => {
    if (!event1Id) throw new Error('No event ID');
    const res = await request('POST', `/events/${event1Id}/join`, {}, {
      'Authorization': `Bearer ${tokens.adi}`,
    });
    if (res.status === 200) throw new Error('Should prevent duplicate join');
  });

  await test('3. Get participants', async () => {
    if (!event1Id) throw new Error('No event ID');
    const res = await request('GET', `/events/${event1Id}/participants`, null, {
      'Authorization': `Bearer ${tokens.adi}`,
    });
    if (res.status !== 200) throw new Error(`Got ${res.status}`);
    console.log(`   → Found ${res.data.participants?.length || 0} participant(s)`);
  });

  // ===== SUMMARY =====
  console.log('\n╔════════════════════════════════════════════════════╗');
  console.log('║   TEST SUMMARY                                       ║');
  console.log('╚════════════════════════════════════════════════════╝\n');

  const passed = results.filter(r => r.status === 'pass').length;
  const total = results.length;
  const percent = ((passed / total) * 100).toFixed(1);

  console.log(`Total: ${total} | Passed: ${passed} ✓ | Failed: ${total - passed} ✗`);
  console.log(`Pass Rate: ${percent}%\n`);

  if (passed === total) {
    console.log('🎉 ALL TESTS PASSED!\n');
  } else {
    console.log('⚠️  SOME TESTS FAILED\n');
  }
})();
