// Copia o CHANGELOG.md de cada projeto para changelog/<slug>.md.
// Uso: node sync.mjs  (rode antes de publicar a Central quando algum projeto lançar versão)
import { copyFileSync, existsSync, mkdirSync } from 'node:fs';
import { join } from 'node:path';

const AQUI = import.meta.dirname;
// slug do projeto na Central -> CHANGELOG.md do repositório do projeto
const FONTES = {
  'lembretes-pje': '../lembretes-pje/CHANGELOG.md',
  'forum-hub': '../pje-services-web/CHANGELOG.md',
};

mkdirSync(join(AQUI, 'changelog'), { recursive: true });
for (const [slug, f] of Object.entries(FONTES)) {
  if (!existsSync(join(AQUI, f))) { console.warn(`aviso: ${f} não encontrado — ${slug} usará as versões inline do index.html`); continue; }
  copyFileSync(join(AQUI, f), join(AQUI, 'changelog', `${slug}.md`));
  console.log(`changelog/${slug}.md atualizado`);
}
