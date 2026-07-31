import { z } from 'zod';

import { GENDERS, SKIN_CONCERNS, SKIN_TYPES } from './user.model';

export const updateMeSchema = z
  .object({
    name: z.string().trim().min(2).max(80).optional(),
    avatarUrl: z.url().nullable().optional(),
  })
  .refine((body) => Object.keys(body).length > 0, {
    message: 'Provide at least one field to update',
  });

export const skinProfileSchema = z.object({
  age: z.number().int().min(13).max(120).optional(),
  gender: z.enum(GENDERS).optional(),
  skinType: z.enum(SKIN_TYPES),
  concerns: z.array(z.enum(SKIN_CONCERNS)).max(9).default([]),
  allergies: z.array(z.string().trim().min(1).max(60)).max(30).default([]),
  preferredIngredients: z
    .array(z.string().trim().min(1).max(60))
    .max(30)
    .default([]),
  avoidIngredients: z
    .array(z.string().trim().min(1).max(60))
    .max(30)
    .default([]),
  goals: z.array(z.string().trim().min(1).max(80)).max(10).default([]),
});

export type SkinProfileInput = z.infer<typeof skinProfileSchema>;
