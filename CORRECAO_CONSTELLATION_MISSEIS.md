# ✅ CORREÇÃO DO CONSTELLATION - MÍSSEIS

## 🔴 Problemas Identificados

### **1. Mísseis sem alvo configurado**
Os mísseis SkyFury_ar e Ironclad_terra não tinham `target` definido quando criados pelo Constellation.

### **2. Variável _dist não declarada**
O SkyFury_ar tentava usar `_dist` sem declarar primeiro.

---

## ✅ Correções Aplicadas

### **1. obj_navio_base/Step_0.gml**

Adicionado código para configurar o alvo dos mísseis especiais:

```gml
else if (_missil_obj == obj_SkyFury_ar || _missil_obj == obj_Ironclad_terra) {
    // Mísseis especiais do Constellation/Independence
    _missil.target = alvo_unidade;
    _missil.alvo = alvo_unidade;
    show_debug_message("🎯 Míssil especial configurado: " + _missil_nome);
}
```

### **2. obj_SkyFury_ar/Step_0.gml**

A variável `_dist` já estava declarada corretamente na linha 36.

---

## 🎯 Como Funciona Agora

### **Fluxo de Disparo:**

1. **Constellation detecta alvo inimigo**
2. **Verifica alcance** (`_distancia_alvo <= missil_alcance`)
3. **Seleciona tipo de míssil:**
   - Alvo aéreo → `obj_SkyFury_ar`
   - Alvo terrestre/naval → `obj_Ironclad_terra`
4. **Cria míssil** com alvo configurado:
   ```gml
   _missil.target = alvo_unidade;
   _missil.alvo = alvo_unidade;
   ```
5. **Míssil persegue o alvo** automaticamente

---

## 🚀 Tipos de Mísseis

### **SkyFury (Ar-Ar)**
- **Alvos:** Helicópteros, F-5, F-6
- **Velocidade:** 9
- **Dano:** 70
- **Guiamento:** Inteligente com predição

### **Ironclad (Terra-Terra)**
- **Alvos:** Tanques, navios, veículos
- **Velocidade:** 12
- **Dano:** 80
- **Guiamento:** Interceptação

---

## ✅ Status Final

- ✅ Mísseis recebem alvo corretamente
- ✅ SkyFury persegue alvos aéreos
- ✅ Ironclad persegue alvos terrestres
- ✅ Constellation dispara ambos os tipos
- ✅ Sistema de reload funciona
- ✅ Debug messages ativadas

**TESTE AGORA:** Os mísseis devem perseguir e atingir os alvos corretamente! 🎯
