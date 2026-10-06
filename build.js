// Vercel build step: writes config.js from environment variables so the
// Supabase values live in Vercel settings instead of in the repo.
const fs = require('fs');
const url = process.env.SUPABASE_URL;
const key = process.env.SUPABASE_ANON_KEY;
if (!url || !key) {
  console.error('Set SUPABASE_URL and SUPABASE_ANON_KEY in the Vercel project settings.');
  process.exit(1);
}
fs.writeFileSync('config.js',
  'window.JOTTER_CONFIG = ' + JSON.stringify({ supabaseUrl: url, supabaseKey: key }, null, 2) + ';\n');
console.log('config.js written');
