import http from 'http';
import { networkInterfaces } from 'os';

import { createApp } from './app';
import { connectDatabase, disconnectDatabase } from './config/db';
import { env } from './config/env';
import { logger } from './config/logger';

/**
 * Non-internal IPv4 addresses, labelled with their interface name. A dev
 * machine usually has several (WSL, Docker, VirtualBox, hotspot), and only
 * the physical Wi-Fi/Ethernet one is reachable from a phone — so the name is
 * shown to make the right choice obvious.
 */
function lanAddresses(): { name: string; address: string }[] {
  return Object.entries(networkInterfaces()).flatMap(([name, entries]) =>
    (entries ?? [])
      .filter((details) => details.family === 'IPv4' && !details.internal)
      .map((details) => ({ name, address: details.address })),
  );
}

/** Virtual adapters a phone can never reach — de-prioritised in the output. */
const VIRTUAL_ADAPTER = /wsl|docker|virtualbox|vethernet|hyper-v|loopback/i;

async function main(): Promise<void> {
  await connectDatabase();

  const app = createApp();
  const server = http.createServer(app);

  // Binding 0.0.0.0 (the default) accepts connections on every interface, so
  // a phone on the same Wi-Fi can reach the API — not just this machine.
  server.listen(env.PORT, env.HOST, () => {
    logger.info(
      `Healthify API listening on http://localhost:${env.PORT} ` +
        `(bound to ${env.HOST}, ${env.NODE_ENV})`,
    );
    logger.info(`Swagger docs: http://localhost:${env.PORT}/api/docs`);

    const addresses = lanAddresses().sort(
      (a, b) =>
        Number(VIRTUAL_ADAPTER.test(a.name)) -
        Number(VIRTUAL_ADAPTER.test(b.name)),
    );
    if (addresses.length > 0) {
      logger.info(
        'To run the Flutter app on a physical device, use your Wi-Fi ' +
          'address below (virtual adapters are listed last):',
      );
      for (const { name, address } of addresses) {
        logger.info(
          `  [${name}] flutter run --dart-define=HEALTHIFY_API_BASE_URL=` +
            `http://${address}:${env.PORT}/api/v1`,
        );
      }
    }
  });

  const shutdown = (signal: string): void => {
    logger.info(`${signal} received — shutting down gracefully`);
    server.close(() => {
      void disconnectDatabase().finally(() => process.exit(0));
    });
  };

  process.on('SIGINT', () => shutdown('SIGINT'));
  process.on('SIGTERM', () => shutdown('SIGTERM'));
}

main().catch((error: unknown) => {
  logger.error('Failed to start server', { error });
  process.exit(1);
});
