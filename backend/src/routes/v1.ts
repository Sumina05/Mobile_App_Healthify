import { Router } from 'express';

import adminRoutes from '../modules/admin/admin.routes';
import analysisRoutes from '../modules/analysis/analysis.routes';
import authRoutes from '../modules/auth/auth.routes';
import chatRoutes from '../modules/chat/chat.routes';
import premiumRoutes from '../modules/premium/premium.routes';
import productRoutes from '../modules/products/product.routes';
import dashboardRoutes from '../modules/dashboard/dashboard.routes';
import favoriteRoutes from '../modules/favorites/favorite.routes';
import healthRoutes from '../modules/health/health.routes';
import ingredientRoutes from '../modules/ingredients/ingredient.routes';
import notificationRoutes from '../modules/notifications/notification.routes';
import userRoutes from '../modules/users/user.routes';

const v1Router = Router();

v1Router.use('/health', healthRoutes);
v1Router.use('/auth', authRoutes);
v1Router.use('/users', userRoutes);
v1Router.use('/ingredients', ingredientRoutes);
v1Router.use('/analysis', analysisRoutes);
v1Router.use('/favorites', favoriteRoutes);
v1Router.use('/notifications', notificationRoutes);
v1Router.use('/dashboard', dashboardRoutes);
v1Router.use('/chat', chatRoutes);
v1Router.use('/products', productRoutes);
v1Router.use('/premium', premiumRoutes);
v1Router.use('/admin', adminRoutes);

export default v1Router;
