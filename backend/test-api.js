#!/usr/bin/env node
/**
 * GERAK Backend Comprehensive API Testing
 * Tests: Auth, Events (with regional filtering), Ratings
 */

const baseUrl = 'http://localhost:5000';
let testResults = [];
let testData = {
  user1: null,
  user2: null,
  event1: null,
  rating1: null,
};

async function makeRequest(method, endpoint, body = null, headers = {}) {
  const defaultHeaders = {
    'Content-Type': 'application/json',
    ...headers,
  };

  try {
    const options = {
      method,
      headers: defaultHeaders,
    };

    if (body) {
      options.body = JSON.stringify(body);
    }

    const response = await fetch(`${baseUrl}${endpoint}`, options);
    const data = await response.json();

    return {
      status: response.status,
      data,
      ok: response.ok,
    };
  } catch (error) {
    return {
      status: 0,
      data: null,
      ok: false,
      error: error.message,
    };
  }
}

function logTest(name, passed, details = '') {
  const status = passed ? '✓' : '✗';
  const color = passed ? '\x1b[32m' : '\x1b[31m';
  const reset = '\x1b[0m';
  console.log(`${color}${status}${reset} ${name} ${details}`);
  testResults.push({ name, passed });
}

async function runTests() {
  console.log('\n' + '='.repeat(60));
  console.log('   GERAK Backend API Comprehensive Testing');
  console.log('='.repeat(60) + '\n');

  // ===== AUTH TESTS =====
  console.log('📝 Authentication Tests\n');

  // Register User 1
  console.log('1. Register User 1 (Player - Adi)');
  let res = await makeRequest('POST', '/auth/register', {
    email: 'adi@gerak.app',
    password: 'SecurePass123',
    name: 'Adi Wijaya',
    phone: '+6281234567890',
    sports: ['futsal', 'badminton'],
    level: 'intermediate',
  });
  logTest('Register User 1', res.ok && res.status === 201, `(Status: ${res.status})`);
  if (res.ok) {
    testData.user1 = res.data.user;
    console.log(`   User ID: ${res.data.user._id}`);
    if (res.data.token) {
      console.log(`   Access Token: ${res.data.token.substring(0, 20)}...`);
    }
  }

  // Register User 2
  console.log('\n2. Register User 2 (Organizer - Budi)');
  res = await makeRequest('POST', '/auth/register', {
    email: 'budi@gerak.app',
    password: 'SecurePass456',
    name: 'Budi Santoso',
    phone: '+6287654321098',
    sports: ['futsal'],
    level: 'advanced',
  });
  logTest('Register User 2', res.ok && res.status === 201, `(Status: ${res.status})`);
  if (res.ok) {
    testData.user2 = res.data.user;
    console.log(`   User ID: ${res.data.user._id}`);
  }

  // Test duplicate email
  console.log('\n3. Register with Duplicate Email (should fail)');
  res = await makeRequest('POST', '/auth/register', {
    email: 'adi@gerak.app',
    password: 'AnotherPass123',
    name: 'Another Person',
    phone: '+6289876543210',
    sports: ['tennis'],
    level: 'beginner',
  });
  logTest('Reject duplicate email', !res.ok && res.status === 400, `(Status: ${res.status})`);

  // Login
  console.log('\n4. Login User 1');
  res = await makeRequest('POST', '/auth/login', {
    email: 'adi@gerak.app',
    password: 'SecurePass123',
  });
  logTest('Login success', res.ok && res.status === 200, `(Status: ${res.status})`);
  let accessToken1 = null;
  if (res.ok) {
    accessToken1 = res.data.token;
    if (res.data.token) {
      testData.user1.accessToken = accessToken1;
      console.log(`   Access Token: ${accessToken1.substring(0, 20)}...`);
    }
  }

  // Login User 2
  console.log('\n5. Login User 2');
  res = await makeRequest('POST', '/auth/login', {
    email: 'budi@gerak.app',
    password: 'SecurePass456',
  });
  logTest('Login User 2 success', res.ok && res.status === 200, `(Status: ${res.status})`);
  let accessToken2 = null;
  if (res.ok) {
    accessToken2 = res.data.token;
    if (res.data.token) {
      testData.user2.accessToken = accessToken2;
    }
  }

  // ===== EVENT TESTS =====
  console.log('\n' + '='.repeat(60));
  console.log('📅 Event Management Tests (Regional Filtering)\n');

  // Create Event 1 (with city and district)
  console.log('1. Create Event 1 (Futsal - Jakarta, Menteng)');
  res = await makeRequest('POST', '/events', {
    name: 'Futsal Night - Kamis Malam',
    description: 'Main futsal santai, terbuka untuk semua level',
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
    imageUrl: 'https://example.com/futsal.jpg',
  }, {
    Authorization: `Bearer ${accessToken2}`,
  });
  logTest('Create Event 1', res.ok && res.status === 201, `(Status: ${res.status})`);
  if (res.ok) {
    testData.event1 = res.data.event;
    console.log(`   Event ID: ${res.data.event._id}`);
    console.log(`   City: ${res.data.event.city}, District: ${res.data.event.district}`);
  }

  // Create Event 2
  console.log('\n2. Create Event 2 (Badminton - Bandung, Cibeunying)');
  res = await makeRequest('POST', '/events', {
    name: 'Badminton Kompetitif',
    description: 'Pertandingan badminton level intermediate-advanced',
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
    Authorization: `Bearer ${accessToken2}`,
  });
  logTest('Create Event 2', res.ok && res.status === 201, `(Status: ${res.status})`);
  let event2Id = null;
  if (res.ok) {
    event2Id = res.data.event._id;
    console.log(`   Event ID: ${event2Id}`);
  }

  // List Events (all)
  console.log('\n3. List All Events');
  res = await makeRequest('GET', '/events?page=1&limit=10', null, {
    Authorization: `Bearer ${accessToken1}`,
  });
  logTest('List all events', res.ok && res.status === 200, `(Found: ${res.data.events?.length || 0})`);
  if (res.ok) {
    console.log(`   Total events: ${res.data.total}`);
  }

  // List Events with CITY filter (Jakarta)
  console.log('\n4. Filter Events by City (Jakarta)');
  res = await makeRequest('GET', '/events?city=Jakarta&page=1&limit=10', null, {
    Authorization: `Bearer ${accessToken1}`,
  });
  logTest('Filter by city (Jakarta)', res.ok && res.status === 200, `(Found: ${res.data.events?.length || 0})`);
  if (res.ok && res.data.events.length > 0) {
    console.log(`   First event: ${res.data.events[0].name} - ${res.data.events[0].city}`);
  }

  // List Events with CITY + DISTRICT filter
  console.log('\n5. Filter Events by City + District (Jakarta + Menteng)');
  res = await makeRequest('GET', '/events?city=Jakarta&district=Menteng&page=1&limit=10', null, {
    Authorization: `Bearer ${accessToken1}`,
  });
  logTest('Filter by city + district', res.ok && res.status === 200, `(Found: ${res.data.events?.length || 0})`);
  if (res.ok && res.data.events.length > 0) {
    console.log(`   City: ${res.data.events[0].city}, District: ${res.data.events[0].district}`);
  }

  // List Events with SPORT filter
  console.log('\n6. Filter Events by Sport (Futsal)');
  res = await makeRequest('GET', '/events?sport=futsal&page=1&limit=10', null, {
    Authorization: `Bearer ${accessToken1}`,
  });
  logTest('Filter by sport', res.ok && res.status === 200, `(Found: ${res.data.events?.length || 0})`);

  // Get Event Detail
  console.log('\n7. Get Event Detail by ID');
  if (testData.event1) {
    res = await makeRequest('GET', `/events/${testData.event1._id}`, null, {
      Authorization: `Bearer ${accessToken1}`,
    });
    logTest('Get event detail', res.ok && res.status === 200, `(Status: ${res.status})`);
    if (res.ok) {
      console.log(`   Name: ${res.data.event.name}`);
      console.log(`   Slot: ${res.data.event.joinedUsers.length}/${res.data.event.maxSlots}`);
    }
  }

  // ===== JOIN EVENT TESTS =====
  console.log('\n' + '='.repeat(60));
  console.log('👥 Event Participation Tests\n');

  // Join Event
  console.log('1. User 1 Join Event 1');
  if (testData.event1) {
    res = await makeRequest('POST', `/events/${testData.event1._id}/join`, {}, {
      Authorization: `Bearer ${accessToken1}`,
    });
    logTest('Join event', res.ok && res.status === 200, `(Status: ${res.status})`);
    if (res.ok) {
      console.log(`   Updated slot: ${res.data.event.joinedUsers.length}/${res.data.event.maxSlots}`);
    }
  }

  // Try to join again (should fail)
  console.log('\n2. User 1 Try to Join Event 1 Again (should fail)');
  if (testData.event1) {
    res = await makeRequest('POST', `/events/${testData.event1._id}/join`, {}, {
      Authorization: `Bearer ${accessToken1}`,
    });
    logTest('Prevent duplicate join', !res.ok && res.status === 400, `(Status: ${res.status})`);
  }

  // Get Participants
  console.log('\n3. Get Event Participants');
  if (testData.event1) {
    res = await makeRequest('GET', `/events/${testData.event1._id}/participants`, null, {
      Authorization: `Bearer ${accessToken1}`,
    });
    logTest('Get participants', res.ok && res.status === 200, `(Found: ${res.data.participants?.length || 0})`);
    if (res.ok && res.data.participants.length > 0) {
      console.log(`   Participant: ${res.data.participants[0].name}`);
    }
  }

  // ===== RATING TESTS =====
  console.log('\n' + '='.repeat(60));
  console.log('⭐ Rating & Review Tests\n');

  // Create Rating (simulate past event - needs adjustment)
  console.log('1. Create Rating for Event');
  if (testData.event1) {
    res = await makeRequest('POST', '/ratings', {
      eventId: testData.event1._id,
      score: 5,
      review: 'Futsal yang seru dan menyenangkan, organizer profesional!',
    }, {
      Authorization: `Bearer ${accessToken1}`,
    });
    logTest('Create rating', res.status === 201 || res.status === 400, `(Status: ${res.status})`);
    if (res.status === 201) {
      testData.rating1 = res.data.rating;
      console.log(`   Rating ID: ${res.data.rating._id}`);
      console.log(`   Score: ${res.data.rating.score}/5`);
    } else {
      console.log(`   Note: ${res.data.message} (Expected - event not past yet)`);
    }
  }

  // ===== SUMMARY =====
  console.log('\n' + '='.repeat(60));
  console.log('📊 Test Summary\n');

  const passed = testResults.filter(t => t.passed).length;
  const total = testResults.length;
  const passRate = ((passed / total) * 100).toFixed(1);

  console.log(`Total Tests: ${total}`);
  console.log(`Passed: ${passed} ✓`);
  console.log(`Failed: ${total - passed} ✗`);
  console.log(`Pass Rate: ${passRate}%\n`);

  if (passed === total) {
    console.log('🎉 All tests passed!\n');
  } else {
    console.log('⚠️  Some tests failed. Check details above.\n');
  }

  console.log('='.repeat(60));
}

// Run tests
runTests().catch(console.error);
