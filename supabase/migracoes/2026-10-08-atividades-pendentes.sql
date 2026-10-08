-- Migração: atividades pendentes (visíveis só para o administrador).
-- Execute no SQL Editor em projetos criados antes desta data. Instalações novas já têm isso no schema.sql.

alter table public.atividades
  add column if not exists status text not null default 'concluida'
  check (status in ('pendente', 'concluida'));

create index if not exists atividades_status_idx on public.atividades (status);

drop policy if exists "leitura publica" on public.atividades;
drop policy if exists "leitura admin"   on public.atividades;

create policy "leitura publica" on public.atividades for select using (status = 'concluida');
create policy "leitura admin"   on public.atividades for select to authenticated using (true);
