# Central de Sistemas — Comarca de Rio Real

Site estático: `index.html` + imagens + downloads. Publique em qualquer hospedagem estática (Vercel a partir do repositório privado, por exemplo). Não há build nem servidor.

## Diário de desenvolvimento (Firebase)

O diário fica no Firestore e é editado pela própria página, após login com e-mail e senha.

Configuração única:

1. `index.html` → constante `FIREBASE`: já aponta para o projeto `lembrentespje` (o mesmo da extensão Lembretes PJe). Para usar outro projeto, troque `apiKey`, `authDomain` e `projectId`.
2. No console do Firebase, em **Firestore → Regras**, acrescente o bloco de `firestore.rules` trocando `SEU-EMAIL-AQUI` pelo e-mail da sua conta.
3. **Authentication → E-mail/senha** precisa estar ativo (já está no projeto da extensão) e a conta do e-mail acima precisa existir.

Uso: *Diário de desenvolvimento* → Entrar → escrever → Publicar. Dá para escolher a data e o projeto, editar e excluir. Visitantes veem tudo em tempo real, sem login.

## Versões dos projetos

Cada projeto mantém seu `CHANGELOG.md` (`## 0.6.0 — AAAA-MM-DD` + itens `- ...`). Ao lançar versão:

```
node sync.mjs
```

copia para `changelog/<slug>.md`; faça commit e publique. Projetos sem CHANGELOG usam `versoes` inline no `index.html`.

## Local

```
python -m http.server 8765
```
