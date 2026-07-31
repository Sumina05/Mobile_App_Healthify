import { defineConfig } from 'vitest/config';

export default defineConfig({
  test: {
    environment: 'node',
    // E2E files share the healthify_test database — run files serially.
    fileParallelism: false,
    include: ['tests/**/*.test.ts'],
    env: {
      NODE_ENV: 'test',
    },
  },
});
