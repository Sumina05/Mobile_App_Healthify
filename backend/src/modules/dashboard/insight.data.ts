/** Rotating daily skin insights shown on the dashboard hero. */
export const DAILY_INSIGHTS = [
  {
    title: 'Layer light to heavy',
    body: 'Apply products from thinnest to thickest texture — water serums first, creams and oils last — so every layer can absorb.',
    tag: 'Routine',
  },
  {
    title: 'SPF is the best anti-ager',
    body: 'Daily sunscreen prevents up to 80% of visible aging. Reapply every 2–3 hours when outdoors.',
    tag: 'Protection',
  },
  {
    title: 'Damp skin drinks better',
    body: 'Humectants like hyaluronic acid work best on slightly damp skin — pat, don’t towel dry, before your serum.',
    tag: 'Hydration',
  },
  {
    title: 'Introduce one active at a time',
    body: 'Give each new active 2–4 weeks alone before adding another. It makes irritation easy to trace.',
    tag: 'Actives',
  },
  {
    title: 'Patch test new products',
    body: 'Apply a little behind the ear or on the inner forearm for 3 nights before using a new product on your face.',
    tag: 'Safety',
  },
  {
    title: 'Night is repair time',
    body: 'Skin regeneration peaks while you sleep — night is the ideal slot for retinoids and richer moisturizers.',
    tag: 'Routine',
  },
  {
    title: 'Don’t over-exfoliate',
    body: 'Most skin types need exfoliating acids only 2–3 times a week. Tight, shiny skin is a warning sign, not a glow.',
    tag: 'Actives',
  },
  {
    title: 'Check the first five',
    body: 'Ingredients are listed by concentration — the first five tell you most of what a formula really is.',
    tag: 'Ingredients',
  },
  {
    title: 'Fragrance-free ≠ unscented',
    body: '“Unscented” products may contain masking fragrance. Sensitive skin should look for “fragrance-free” on the label.',
    tag: 'Ingredients',
  },
  {
    title: 'Consistency beats intensity',
    body: 'A simple routine done daily outperforms an elaborate one done occasionally. Skin rewards rhythm.',
    tag: 'Mindset',
  },
] as const;

export function insightOfTheDay() {
  const dayNumber = Math.floor(Date.now() / 86_400_000);
  return DAILY_INSIGHTS[dayNumber % DAILY_INSIGHTS.length];
}
