# 🛠️ GUIA DE MANUTENIBILIDADE - HEGEMONIA GLOBAL

**Data:** 2025-01-27  
**Objetivo:** Melhorar a manutenibilidade do código e organização do projeto

---

## 📋 PROBLEMAS IDENTIFICADOS E SOLUÇÕES

### 1. ✅ Scripts de Teste Misturados

**Problema:** Mais de 100 scripts de teste (`scr_teste_*`) misturados com scripts de produção na pasta `scripts/`.

**Solução Implementada:**
- Criada pasta `tests/` para scripts de teste
- Scripts de teste movidos para `tests/scripts/`
- Scripts de produção permanecem em `scripts/`

**Estrutura:**
```
scripts/          → Scripts de produção
tests/
  └── scripts/    → Scripts de teste (scr_teste_*)
```

**Benefícios:**
- Separação clara entre código de produção e teste
- Facilita identificação de scripts obsoletos
- Melhora navegação no projeto

---

### 2. ✅ Documentação Fragmentada

**Problema:** 445 arquivos `.md` pequenos e fragmentados na raiz do projeto.

**Solução Implementada:**
- Criada pasta `docs/` para documentação
- Documentação organizada por categoria:
  - `docs/correcoes/` - Correções de bugs
  - `docs/implementacoes/` - Implementações de features
  - `docs/guias/` - Guias e tutoriais
  - `docs/relatorios/` - Relatórios e análises
  - `docs/changelogs/` - Histórico de mudanças

**Estrutura:**
```
docs/
├── correcoes/        → Correções de bugs
├── implementacoes/   → Implementações de features
├── guias/            → Guias e tutoriais
├── relatorios/       → Relatórios e análises
├── changelogs/       → Histórico de mudanças
└── GUIA_MANUTENIBILIDADE.md (este arquivo)
```

**Benefícios:**
- Documentação organizada e fácil de encontrar
- Reduz poluição na raiz do projeto
- Facilita manutenção e atualização

---

### 3. ✅ Código Defensivo Excessivo

**Problema:** Muitas verificações de existência (`instance_exists`, `variable_exists`, etc.) sendo usadas de forma excessiva, tornando o código verboso e difícil de ler.

**Solução:** Guia de boas práticas sobre quando usar verificações defensivas.

**Regras:**

#### ✅ **QUANDO USAR Verificações Defensivas:**

1. **Acesso a instâncias que podem ser destruídas:**
```gml
// ✅ CORRETO: Instância pode ser destruída durante execução
if (instance_exists(alvo)) {
    var _hp = alvo.hp_atual;
}
```

2. **Acesso a variáveis globais que podem não existir:**
```gml
// ✅ CORRETO: Variável global pode não ter sido inicializada
if (variable_global_exists("estoque_recursos")) {
    var _valor = global.estoque_recursos[? "Dinheiro"];
}
```

3. **Acesso a data structures que podem ser destruídas:**
```gml
// ✅ CORRETO: DS pode ter sido destruída
if (ds_exists(global.lista_unidades, ds_type_list)) {
    var _count = ds_list_size(global.lista_unidades);
}
```

4. **Em funções utilitárias genéricas:**
```gml
// ✅ CORRETO: Função genérica deve validar entrada
function scr_obter_hp_unidade(_id) {
    if (!instance_exists(_id)) return -1;
    if (!variable_instance_exists(_id, "hp_atual")) return -1;
    return _id.hp_atual;
}
```

#### ❌ **QUANDO NÃO USAR Verificações Defensivas:**

1. **Variáveis de instância própria:**
```gml
// ❌ ERRADO: Variável própria sempre existe
if (variable_instance_exists(id, "hp_atual")) {
    var _hp = hp_atual;
}

// ✅ CORRETO: Acesso direto
var _hp = hp_atual;
```

2. **Objetos definidos no projeto:**
```gml
// ❌ ERRADO: Objeto existe no projeto
if (object_exists(obj_quartel)) {
    instance_create_layer(x, y, "Instances", obj_quartel);
}

// ✅ CORRETO: Acesso direto (se objeto existe no projeto)
instance_create_layer(x, y, "Instances", obj_quartel);
```

3. **Variáveis locais:**
```gml
// ❌ ERRADO: Variável local sempre existe no escopo
if (variable_instance_exists(id, "_temp")) {
    var _temp = 10;
}

// ✅ CORRETO: Declaração direta
var _temp = 10;
```

4. **Enums e constantes:**
```gml
// ❌ ERRADO: Enum sempre existe
if (variable_global_exists("EstadoUnidade")) {
    var _estado = EstadoUnidade.PARADO;
}

// ✅ CORRETO: Acesso direto
var _estado = EstadoUnidade.PARADO;
```

#### 🎯 **PRINCÍPIO GERAL:**

**Use verificações defensivas apenas quando:**
- A existência do recurso não é garantida
- O recurso pode ser destruído durante a execução
- A função é genérica e recebe parâmetros externos
- Há risco real de erro em runtime

**Evite verificações defensivas quando:**
- O recurso é garantido (variáveis próprias, objetos do projeto)
- A verificação adiciona complexidade sem benefício
- O código fica mais difícil de ler

---

## 📁 ESTRUTURA DO PROJETO RECOMENDADA

```
Hegemonia-2-1/
├── scripts/              → Scripts de produção
│   ├── scr_ia_*/         → Scripts de IA
│   ├── scr_sistema_*/    → Scripts de sistema
│   └── ...
│
├── tests/                → Testes e scripts de teste
│   └── scripts/          → Scripts de teste (scr_teste_*)
│
├── docs/                 → Documentação
│   ├── correcoes/        → Correções de bugs
│   ├── implementacoes/   → Implementações
│   ├── guias/            → Guias e tutoriais
│   ├── relatorios/       → Relatórios
│   └── changelogs/       → Histórico
│
├── objects/              → Objetos do jogo
├── sprites/              → Sprites
├── rooms/                → Salas
├── sounds/               → Sons
└── README.md             → Documentação principal
```

---

## 🔧 PRÓXIMOS PASSOS

1. ✅ Estrutura de pastas criada
2. ⏳ Mover scripts de teste para `tests/scripts/`
3. ⏳ Organizar documentação em `docs/`
4. ⏳ Revisar código defensivo excessivo
5. ⏳ Atualizar referências nos arquivos

---

## 📚 REFERÊNCIAS

- `GUIA_CODIGO_DEFENSIVO.md` - Guia detalhado sobre código defensivo
- `ESTRUTURA_PROJETO.md` - Estrutura completa do projeto

---

**Última atualização:** 2025-01-27

