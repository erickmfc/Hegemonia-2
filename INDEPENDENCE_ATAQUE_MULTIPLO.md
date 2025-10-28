# 🚢 INDEPENDENCE - SISTEMA DE ATAQUE MÚLTIPLO

## 📋 **DESCRIÇÃO**

O Independence agora ataca **TODOS os inimigos** dentro do raio simultaneamente, não apenas um alvo único.

---

## 🎯 **FUNCIONALIDADES**

### **Detecção Múltipla:**
- ✅ Detecta TODOS os inimigos dentro do raio (1000px)
- ✅ Separa automaticamente em aéreos e terrestres
- ✅ Conta e lista todos os alvos encontrados

### **Ataque em Alvos Terrestres:**
- ✅ Canhão dispara em **MÚLTIPLOS alvos** ao mesmo tempo
- ✅ Cria um projétil para cada alvo terrestre
- ✅ Máximo de 3 tiros por frame (performance)
- ✅ Distribui rajada entre todos os alvos

### **Ataque em Alvos Aéreos:**
- ✅ Mísseis SkyFury disparados automaticamente
- ✅ Gerenciado pelo obj_navio_base
- ✅ Um míssil por alvo aéreo

---

## ⚙️ **TIPOS DE INIMIGOS DETECTADOS**

| Tipo | Objeto | Categoria |
|------|--------|-----------|
| **Navios** | obj_navio_base | Terrestre/Naval |
| **Helicópteros** | obj_helicoptero_militar | Aéreo |
| **F-5** | obj_caca_f5 | Aéreo |
| **F-6** | obj_f6 | Aéreo |
| **Infantaria** | obj_infantaria | Terrestre |
| **Inimigos** | obj_inimigo | Terrestre |

---

## 🎮 **MECÂNICA DE COMBATE**

### **Fluxo de Ataque:**

```
Modo ATAQUE ativado
↓
Detectar TODOS os inimigos no raio
↓
Separar em aéreos e terrestres
↓
┌─────────────────────────┬─────────────────────────┐
│ ALVOS TERRESTRES        │ ALVOS AÉREOS            │
│ (Canhão)                │ (Mísseis)               │
├─────────────────────────┼─────────────────────────┤
│ 1. Ativar metralhadora  │ 1. Sistema automático  │
│ 2. Para cada alvo:     │ 2. Dispara SkyFury     │
│    - Criar projétil     │ 3. Um por alvo          │
│    - Definir alvo       │                         │
│ 3. Máx 3 tiros/frame   │                         │
│ 4. Distribuir rajada   │                         │
└─────────────────────────┴─────────────────────────┘
```

### **Sistema de Rajada:**

- **Rajada Total**: 60 tiros em 3 segundos
- **Tiros por Frame**: Máximo 3 (performance)
- **Distribuição**: Tiros são distribuídos entre todos os alvos terrestres
- **Cooldown**: 3 segundos de pausa após rajada

### **Exemplos:**

**Cenário 1 - 3 Navios Inimigos:**
- Independence detecta 3 navios
- Dispara 3 projéteis por vez (máximo por frame)
- Distribui os 60 tiros entre os 3 navios
- Cada navio recebe aproximadamente 20 tiros

**Cenário 2 - 1 Navio + 2 Helicópteros:**
- Independence detecta 1 navio + 2 helicópteros
- Canhão atira no navio (projéteis)
- Mísseis disparam nos helicópteros (SkyFury)
- Combinação de canhão + mísseis

---

## 🔧 **DETALHES TÉCNICOS**

### **Detecção de Inimigos:**

```gml
// Para cada tipo de inimigo:
with (obj_tipo) {
    if (nacao_proprietaria != 1 && nacao_proprietaria != other.nacao_proprietaria) {
        var _dist = point_distance(other.x, other.y, x, y);
        if (_dist <= other.missil_max_alcance) {
            array_push(_lista_alvos, {
                id: id,
                distancia: _dist,
                tipo: "categoria"
            });
        }
    }
}
```

### **Sistema de Tiros Múltiplos:**

```gml
// Máximo de 3 tiros por frame (performance)
var _max_tiros_por_frame = 3;

for (var i = 0; i < _num_alvos_terrestres && _tiros_este_frame < _max_tiros_por_frame; i++) {
    var _alvo = _inimigos_terrestres[i];
    var _tiro = instance_create_layer(canhao_instancia.x, canhao_instancia.y, "Instances", obj_tiro_canhao);
    _tiro.alvo = _alvo;
    _tiro.dono = id;
}
```

---

## 📊 **ESTATÍSTICAS**

| Propriedade | Valor |
|------------|-------|
| **Raio de Detecção** | 1000px |
| **Tiros por Rajada** | 60 |
| **Duração da Rajada** | 3 segundos |
| **Cooldown** | 3 segundos |
| **Máx Tiros/Frame** | 3 |
| **Tipos de Alvo** | 6 |

---

## ✅ **VANTAGENS**

### **vs Sistema Antigo:**
- ❌ **Antes**: Atacava 1 alvo por vez
- ✅ **Depois**: Ataca MÚLTIPLOS alvos simultaneamente

### **vs Outros Navios:**
- Independence é o único navio com ataque múltiplo
- Outros navios atacam apenas 1 alvo por vez
- Independence distribui rajada entre vários alvos

### **Eficiência:**
- Enfrenta múltiplos inimigos com eficiência
- Dano distribuído entre vários alvos
- Não precisa escolher qual alvo atacar

---

## 🚀 **RESULTADO**

O Independence agora:
- ✅ Detecta TODOS os inimigos no raio
- ✅ Ataca TODOS simultaneamente
- ✅ Canhão em múltiplos alvos terrestres
- ✅ Mísseis em múltiplos alvos aéreos
- ✅ Sistema de ataque verdadeiramente múltiplo
- ✅ Performance otimizada

---

*Sistema de ataque múltiplo implementado com sucesso!*

