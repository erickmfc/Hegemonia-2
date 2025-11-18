# 📁 ESTRUTURA DO PROJETO - HEGEMONIA GLOBAL

**Data:** 2025-01-27  
**Versão:** 1.2

---

## 🗂️ ESTRUTURA RECOMENDADA

```
Hegemonia-2-1/
│
├── 📁 scripts/                    # Scripts de produção
│   ├── scr_ia_*/                  # Scripts de IA
│   ├── scr_sistema_*/             # Scripts de sistema
│   ├── scr_config_*/              # Scripts de configuração
│   └── ...
│
├── 📁 tests/                      # Testes e scripts de teste
│   └── scripts/                   # Scripts de teste (scr_teste_*)
│       ├── scr_teste_ia_*/
│       ├── scr_teste_quartel_*/
│       └── ...
│
├── 📁 docs/                       # Documentação
│   ├── correcoes/                 # Correções de bugs
│   ├── implementacoes/            # Implementações de features
│   ├── guias/                     # Guias e tutoriais
│   ├── relatorios/                # Relatórios e análises
│   ├── changelogs/                # Histórico de mudanças
│   ├── GUIA_MANUTENIBILIDADE.md
│   ├── GUIA_CODIGO_DEFENSIVO.md
│   └── ESTRUTURA_PROJETO.md (este arquivo)
│
├── 📁 objects/                    # Objetos do jogo
│   ├── obj_game_manager/
│   ├── obj_quartel_*/
│   └── ...
│
├── 📁 sprites/                    # Sprites
├── 📁 rooms/                      # Salas
├── 📁 sounds/                     # Sons
├── 📁 tilesets/                   # Tilesets
├── 📁 fonts/                      # Fontes
│
└── 📄 README.md                   # Documentação principal
```

---

## 📋 DESCRIÇÃO DAS PASTAS

### `scripts/` - Scripts de Produção

**Conteúdo:** Scripts usados no jogo em produção.

**Organização:**
- `scr_ia_*` - Scripts de inteligência artificial
- `scr_sistema_*` - Scripts de sistemas principais
- `scr_config_*` - Scripts de configuração
- `scr_*` - Outros scripts de produção

**Regra:** Nenhum script com prefixo `scr_teste_*` deve estar aqui.

---

### `tests/scripts/` - Scripts de Teste

**Conteúdo:** Scripts de teste e diagnóstico.

**Organização:**
- `scr_teste_*` - Scripts de teste específicos
- `scr_diagnostico_*` - Scripts de diagnóstico

**Regra:** Todos os scripts de teste devem estar aqui.

---

### `docs/` - Documentação

**Conteúdo:** Toda a documentação do projeto.

**Organização:**

#### `docs/correcoes/`
- Correções de bugs
- Exemplos: `CORRECAO_*.md`, `CORRECOES_*.md`

#### `docs/implementacoes/`
- Implementações de features
- Exemplos: `IMPLEMENTACAO_*.md`, `SISTEMA_*.md`

#### `docs/guias/`
- Guias e tutoriais
- Exemplos: `GUIA_*.md`, `COMO_*.md`

#### `docs/relatorios/`
- Relatórios e análises
- Exemplos: `RELATORIO_*.md`, `ANALISE_*.md`

#### `docs/changelogs/`
- Histórico de mudanças
- Exemplos: `CHANGELOG_*.md`

**Regra:** Nenhum arquivo `.md` deve estar na raiz do projeto (exceto `README.md`).

---

## 🎯 REGRAS DE ORGANIZAÇÃO

### Scripts

1. ✅ Scripts de produção em `scripts/`
2. ✅ Scripts de teste em `tests/scripts/`
3. ✅ Nomes descritivos e consistentes
4. ✅ Prefixos claros (`scr_ia_*`, `scr_teste_*`, etc.)

### Documentação

1. ✅ Toda documentação em `docs/`
2. ✅ Organizada por categoria
3. ✅ Nomes descritivos
4. ✅ `README.md` na raiz (único `.md` permitido)

### Objetos

1. ✅ Organizados por funcionalidade
2. ✅ Nomes descritivos
3. ✅ Prefixos consistentes (`obj_*`)

---

## 📊 ESTATÍSTICAS ATUAIS

### Antes da Reorganização:
- Scripts de teste: ~100+ misturados
- Documentação: 445 arquivos `.md` na raiz
- Código defensivo: Excessivo em muitos lugares

### Após Reorganização:
- Scripts de teste: Organizados em `tests/scripts/`
- Documentação: Organizada em `docs/`
- Código defensivo: Guia de boas práticas criado

---

## 🔄 MIGRAÇÃO

### Scripts de Teste

**Antes:**
```
scripts/
├── scr_teste_ia_completo/
├── scr_teste_quartel_funcional/
└── ...
```

**Depois:**
```
tests/scripts/
├── scr_teste_ia_completo/
├── scr_teste_quartel_funcional/
└── ...
```

### Documentação

**Antes:**
```
Hegemonia-2-1/
├── CORRECAO_*.md (muitos)
├── IMPLEMENTACAO_*.md (muitos)
├── GUIA_*.md (muitos)
└── ...
```

**Depois:**
```
docs/
├── correcoes/
│   └── CORRECAO_*.md
├── implementacoes/
│   └── IMPLEMENTACAO_*.md
├── guias/
│   └── GUIA_*.md
└── ...
```

---

## ✅ CHECKLIST DE ORGANIZAÇÃO

- [ ] Scripts de teste movidos para `tests/scripts/`
- [ ] Documentação organizada em `docs/`
- [ ] `README.md` atualizado com nova estrutura
- [ ] Referências atualizadas nos arquivos
- [ ] Código defensivo revisado conforme guia

---

**Última atualização:** 2025-01-27

