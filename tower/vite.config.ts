import { defineConfig } from 'vite';
import react from '@vitejs/plugin-react';

// Served by Vercel at /tower alongside the Flutter build (see scripts/vercel-build.sh).
export default defineConfig({
  base: '/tower/',
  plugins: [react()],
});
