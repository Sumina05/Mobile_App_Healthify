import request from 'supertest';
import { describe, expect, it } from 'vitest';

import { createApp } from '../src/app';

const app = createApp();

describe('GET /api/v1/health', () => {
  it('returns the standard success envelope with service status', async () => {
    const response = await request(app).get('/api/v1/health');

    expect(response.status).toBe(200);
    expect(response.body.success).toBe(true);
    expect(response.body.data.status).toBe('ok');
    expect(['connected', 'disconnected']).toContain(
      response.body.data.database,
    );
  });
});

describe('unknown routes', () => {
  it('returns a 404 error envelope', async () => {
    const response = await request(app).get('/api/v1/does-not-exist');

    expect(response.status).toBe(404);
    expect(response.body.success).toBe(false);
    expect(response.body.message).toContain('not found');
  });
});
