# 🏴‍☠️ SISTEMA DE PIRATAS IMPLEMENTADO

## ✅ Sistema Completo - 3 Tipos de Navios + Pilares Invisíveis

### 📋 Estrutura Criada

#### 1. **Pilar Pirata (Invisível)**
- **Arquivo**: `objects/obj_pilar_pirata/Create_0.gml`
- **Características**:
  - Totalmente invisível (`visible = false`)
  - Marcadores de rota para patrulha
  - Suporta grupos de pilares
  - Apenas visível em modo debug

#### 2. **Navio Pirata Tipo 1 - Rápido e Frágil**
- **Arquivo**: `objects/obj_navio_pirata/Create_0.gml`
- **Stats**:
  - **HP**: 60 (muito frágil)
  - **Velocidade**: 2.0 (rápido)
  - **Dano**: 12
  - **Recarga**: 1.25s
  - **Detecção**: 500px (bom alcance)
  - **Especialidade**: Perseguição

#### 3. **Navio Pirata Tipo 2 - Balanceado**
- **Arquivo**: `objects/obj_navio_pirata2/Create_0.gml`
- **Stats**:
  - **HP**: 80 (médio)
  - **Velocidade**: 1.6 (médio)
  - **Dano**: 15 (médio-alto)
  - **Recarga**: 1.5s
  - **Detecção**: 400px (médio)
  - **Especialidade**: Versátil

#### 4. **Navio Pirata Tipo 3 - Lento e Resistente**
- **Arquivo**: `objects/obj_navio_pirata3/Create_0.gml`
- **Stats**:
  - **HP**: 120 (resistente)
  - **Velocidade**: 1.2 (lento)
  - **Dano**: 20 (alto)
  - **Recarga**: 2.0s
  - **Detecção**: 350px (alcance menor)
  - **Especialidade**: Combate

---

## 🎮 Sistema de Funcionamento

### **Patrulha**
1. Navio pirata é criado
2. Automaticamente busca pilares em 1000px de raio
3. Cria rota circular passando pelos pilares próximos (máx 8)
4. Patrulha infinitamente entre os pilares
5. Aguarda 2-4 segundos em cada pilar (dependendo do tipo)

### **Detecção e Combate**
1. Navio detecta navios inimigos (não nação 3)
2. **Prioridade de alvo**:
   - 1º: Navios de carga
   - 2º: Navios de transporte
   - 3º: Outros navios militares
3. Persegue o alvo até estar no alcance de ataque
4. Atira com dano multiplicado:
   - **vs Carga**: 2.0-2.5x dano
   - **vs Militar**: 0.4-0.6x dano
5. Perde alvo se sair a 1.5x do raio de detecção

---

## 📊 Comparação dos 3 Tipos

| Característica | Tipo 1 (Rápido) | Tipo 2 (Balanceado) | Tipo 3 (Resistente) |
|---|---|---|---|
| **HP** | 60 | 80 | 120 |
| **Velocidade** | 2.0 | 1.6 | 1.2 |
| **Dano** | 12 | 15 | 20 |
| **Recarga** | 1.25s | 1.5s | 2.0s |
| **Raio Detecção** | 500px | 400px | 350px |
| **Tempo Espera** | 2s | 3s | 4s |
| **vs Carga** | 2.5x | 2.0x | 2.5x |
| **vs Militar** | 0.4x | 0.5x | 0.6x |

---

## 🛠️ Arquivos Criados

1. **Objetos**:
   - `objects/obj_pilar_pirata/` (Create, Draw, Destroy)
   - `objects/obj_navio_pirata/` (Create, Step, Draw)
   - `objects/obj_navio_pirata2/` (Create, Step, Draw)
   - `objects/obj_navio_pirata3/` (Create, Step, Draw)

2. **Scripts**:
   - `scripts/scr_vincular_pirata_pilares/scr_vincular_pirata_pilares.gml`

---

## 🎯 Como Usar

### **Passo 1: Posicionar Pilares**
1. Abra o room/sala no GameMaker
2. Insira múltiplas instâncias de `obj_pilar_pirata`
3. Posicione-as em rotas que os navios devem seguir
4. Os pilares são invisíveis no jogo

### **Passo 2: Criar Navios Piratas**
1. Insira instâncias de `obj_navio_pirata`, `obj_navio_pirata2` ou `obj_navio_pirata3`
2. Posicione onde quiser
3. Cada navio busca automaticamente os pilares próximos

### **Passo 3: Executar o Jogo**
- Os navios se vinculam aos pilares automaticamente
- Começam a patrulhar a rota
- Atacam qualquer navio inimigo que detectem

---

## 🔧 Variáveis Principais

### **Patrulha**
- `pilares_patrulha` - Lista de pilares da rota
- `indice_pilar_atual` - Pilar atual na rota
- `estado_patrulha` - "navegando" ou "esperando"
- `timer_espera` - Contador para esperar no pilar

### **Combate**
- `alvo_atual` - Instância do alvo
- `modo_cacando` - true se perseguindo alvo
- `dano_base` - Dano base do navio
- `reload_timer` - Contador para recarregar

### **Multiplicadores**
- `multiplicador_vs_militar` - Reduz dano vs militares
- `multiplicador_vs_carga` - Aumenta dano vs carga

---

## 🐛 Debug

Para ver os pilares em modo debug:
1. Ativar `global.debug_enabled = true`
2. Pilares aparecem como pequenos círculos amarelos

---

## 📝 Resumo

✅ Sistema de 3 navios piratas totalmente funcional  
✅ Patrulha automática entre pilares invisíveis  
✅ Sistema de detecção e combate com prioridades  
✅ Diferentes multiplicadores de dano por tipo de alvo  
✅ Sem modificar código existente das outras unidades  
✅ Integrado com sistema de vida existente (barra de HP)  

Tudo pronto para usar! 🚀

