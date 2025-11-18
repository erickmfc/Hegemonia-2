# 📊 MENU DE RECURSOS SUSPENSO E RECOLHÍVEL

## 🎨 CARACTERÍSTICAS DO DESIGN

### ✨ Visual Neon Ciberpunk

- **Cores**: Neon Cyan (#64DCFF), Azul Escuro (#141928), Amarelo (#FFC864)
- **Efeito Glow**: Bordas pulsantes de neon
- **Transparência**: Fundo semi-transparente com profundidade
- **Ícones**: Emojis para cada tipo de recurso

### 🎬 Animações

- **Expansão/Recolhimento**: Altura transita suavemente (0.5s)
- **Seta Rotativa**: Rotaciona 180° ao expandir
- **Glow Pulsante**: Bordas "respiram" continuamente
- **Hover nos Itens**: Destaque ao passar mouse

### 🎯 Funcionalidades

- **Toggle Automático**: Clique no cabeçalho abre/fecha
- **Sincronização de Recursos**: Conecta com globals automaticamente
- **Formatação Inteligente**: Números grandes em K/M
- **Hover Detection**: Destaque visual ao passar mouse

---

## 📂 ESTRUTURA DE ARQUIVOS

```
obj_menu_recursos_suspenso/
├── Create_0.gml          (Inicialização - 120 linhas)
├── Step_0.gml            (Lógica e Animação - 90 linhas)
├── Draw_64.gml           (Visual Neon - 200+ linhas)
└── Mouse_4.gml           (Toggle - 20 linhas)
```

---

## 🔧 PASSO-A-PASSO DE IMPLEMENTAÇÃO

### PASSO 1: Criar o Objeto

1. Crie um novo **Object** chamado `obj_menu_recursos_suspenso`
2. **NÃO** defina sprite (deixe em branco)
3. **NÃO** marque "Visible"
4. Crie uma instância na Room

---

### PASSO 2: Implementar Create_0.gml

**O que faz:**
- Inicializa posicionamento e animação
- Cria lista de recursos com dados
- Define cores neon

**Principais variáveis:**
- `menu_estado`: 0=Recolhido, 1=Expandindo, 2=Expandido, 3=Recolhendo
- `menu_altura_atual`: Altura que transita dinamicamente
- `seta_angulo`: Rotação da seta (0° ou 180°)
- `lista_recursos`: Array com dados de cada recurso

**Como fazer:**
1. Click direito no objeto → "Create Event"
2. Copie TODO o código do `Create_0.gml`
3. Personalize posição (X e Y iniciais)

---

### PASSO 3: Implementar Step_0.gml

**O que faz:**
- Sincroniza valores com variáveis globais
- Anima expansão/recolhimento
- Detecta hover sobre itens
- Atualiza glow pulsante

**Sincronização automática:**

```
global.dinheiro      → lista_recursos[0].valor
global.populacao     → lista_recursos[1].valor
global.turistas      → lista_recursos[2].valor
global.foida         → lista_recursos[3].valor
global.energia       → lista_recursos[4].valor
global.petrolo       → lista_recursos[5].valor
global.militar       → lista_recursos[6].valor
global.polaridade    → lista_recursos[7].valor
```

**Como fazer:**
1. Click direito no objeto → "Step Event"
2. Copie TODO o código do `Step_0.gml`

---

### PASSO 4: Implementar Draw_64.gml

**O que faz:**
- Desenha borda com glow neon pulsante
- Desenha cabeçalho com seta rotativa
- Desenha itens de recursos
- Aplica efeito hover

**Componentes desenhados:**
1. Sombra do menu
2. Fundo semi-transparente
3. Borda neon com glow (3 camadas)
4. Cabeçalho com ícone e título
5. Seta de toggle (anima conforme estado)
6. Itens de recursos (com hover effect)
7. Valores formatados (50K, 1.2M, etc)

**Como fazer:**
1. Click direito no objeto → "Draw Event" → **"Draw GUI"** (Auto-cria Draw_64)
2. Copie TODO o código do `Draw_64.gml`

---

### PASSO 5: Implementar Mouse_4.gml

**O que faz:**
- Detecta clique no cabeçalho
- Alterna entre expandido/recolhido
- Inicia animação de transição

**Como fazer:**
1. Click direito no objeto → "Mouse Event" → "Left Button Pressed"
2. Copie TODO o código do `Mouse_4.gml`

---

## 🎨 CUSTOMIZAÇÃO

### Mudar Posição Inicial

```gml
menu_pos_x = 30;    // Distância da esquerda
menu_pos_y = 30;    // Distância do topo
```

### Mudar Tamanho

```gml
menu_largura_expandido = 380;  // Largura total
menu_altura_expandido = 520;   // Altura quando aberto
menu_altura_recolhido = 50;    // Altura do cabeçalho
```

### Mudar Cores

```gml
cor_borda_neon = make_color_rgb(100, 220, 255);      // Neon cyan
cor_fundo = make_color_rgb(20, 25, 40);              // Azul escuro
cor_texto_titulo = make_color_rgb(200, 240, 255);    // Azul claro
```

### Mudar Velocidade de Animação

```gml
duracao_animacao = 0.5;   // 0.5 segundos para expandir/recolher
glow_speed = 0.1;         // Velocidade do glow pulsante
```

### Adicionar Novo Recurso

```gml
// No Create_0.gml, após os recursos existentes:
var _novo_recurso = criar_recurso(
    "Nome do Recurso",  // Nome
    "⚡",               // Ícone/Emoji
    100,                // Valor inicial
    make_color_rgb(255, 100, 100),  // Cor
    true                // eh_numero (true para números, false para status)
);
array_push(lista_recursos, _novo_recurso);

// No Step_0.gml, adicione sincronização:
if (variable_global_exists("nome_global")) {
    lista_recursos[numero_indice].valor = global.nome_global;
}
```

---

## 🔌 INTEGRAÇÃO COM SISTEMA EXISTENTE

### Sincronizar Recursos Automaticamente

O menu já sincroniza com globais! No seu código principal, simplesmente atualize:

```gml
global.dinheiro = 50000;
global.populacao = 2000;
global.foida = 1200;
// etc...
```

O menu atualizará automaticamente a cada frame!

### Adicionar Novo Global

1. Crie a variável global no seu código
2. Adicione um `criar_recurso()` no Create_0.gml
3. Adicione sincronização no Step_0.gml

---

## 📊 REFERÊNCIA DE ÍCONES

Você pode usar emojis ou caracteres:

```
"$"   → Dinheiro
"👥"  → População
"🏖"  → Turistas
"🍗"  → Alimento
"⚡"  → Energia
"🛢"  → Petróleo
"⚔"  → Militar
"☮"  → Status
```

Ou criar suas próprias sprites e desenhar com `draw_sprite()`.

---

## 🎬 FLUXO FUNCIONAL

```
Menu Recolhido (Estado 0)
    ↓ [Clique no cabeçalho]
Menu Expandindo (Estado 1) → Anima 0.5s
    ↓
Menu Expandido (Estado 2) → Mostra todos os recursos
    ↓ [Clique no cabeçalho]
Menu Recolhendo (Estado 3) → Anima 0.5s
    ↓
Menu Recolhido (Estado 0)
```

---

## ✅ CHECKLIST DE IMPLEMENTAÇÃO

- [ ] Criado objeto `obj_menu_recursos_suspenso`
- [ ] Create_0.gml implementado
- [ ] Step_0.gml implementado
- [ ] Draw_64.gml implementado (como Draw GUI)
- [ ] Mouse_4.gml implementado
- [ ] Variáveis globais criadas (`global.dinheiro`, etc)
- [ ] Instância criada na Room
- [ ] Menu abre com clique no cabeçalho
- [ ] Menu fecha com clique novamente
- [ ] Valores sincronizam com globals
- [ ] Hover destaca itens
- [ ] Seta rotaciona ao expandir
- [ ] Glow neon está pulsando

---

## 🎨 EFEITOS VISUAIS EXPLICADOS

### Glow Neon

```gml
// Múltiplas camadas de retângulos com alpha decrescente
// Cria efeito de brilho radiante
draw_rectangle(_x1 - 8, _y1 - 8, _x2 + 8, _y2 + 8, false);
draw_rectangle(_x1 - 6, _y1 - 6, _x2 + 6, _y2 + 6, false);
draw_rectangle(_x1 - 4, _y1 - 4, _x2 + 4, _y2 + 4, false);
```

### Pulsação

```gml
// Usa seno para criar oscilação contínua
glow_val = 0.3 + (sin(glow_intensity * 360 * pi / 180) * 0.2);
// Resulta em: 0.1 → 0.5 → 0.1 → 0.5...
```

### Animação Suave

```gml
// Easing cubic para abertura natural
var _ease = 1 - power(1 - _progresso, 3);
menu_altura_atual = lerp(recolhido, expandido, _ease);
```

---

## 🐛 DEBUGGING

### Ativar Debug Messages

```gml
global.debug_enabled = true;
```

### Mensagens Exibidas

```
✅ Menu de Recursos Suspenso inicializado
✅ Menu de Recursos: Expandindo...
✅ Menu de Recursos: Recolhendo...
```

---

## 🔧 TROUBLESHOOTING

**Menu não abre/fecha:**
- Verifique se Click Event (Mouse_4) foi criado
- Confira se o objeto está na Room

**Recursos não atualizam:**
- Verifique se `global.dinheiro`, etc estão sendo alterados
- Confirme que `Create_0.gml` foi copiado corretamente

**Glow não aparece:**
- Verifique se `Draw_64.gml` foi criado como "Draw GUI"
- Aumente `glow_speed` no Create_0.gml

**Itens fora do viewport:**
- O código já trata isso com `if (_item_y2 > _menu_y2) break;`

---

## 📈 PRÓXIMAS MELHORIAS (OPCIONAIS)

1. **Notificações**: Flash ao recurso mudar drasticamente
2. **Barra de Limite**: Mostrar capacidade máxima
3. **Histórico**: Gráfico de recursos ao longo do tempo

---

**🎮 Pronto para implementar! Bom jogo!**

