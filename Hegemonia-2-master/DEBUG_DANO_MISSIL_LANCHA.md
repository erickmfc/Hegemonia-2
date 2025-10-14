# 🔍 DEBUG DO SISTEMA DE DANO DO MÍSSIL DA LANCHA

## 🎯 **Problema Atual**
O míssil da lancha está **acertando o alvo** mas **não está causando dano**. O projétil visual está funcionando, mas o sistema de dano não está aplicando o dano corretamente.

## 🔧 **Debug Implementado**

### **1. Debug Detalhado do Dano**
Adicionado debug completo no momento da colisão:
```gml
show_debug_message("🔍 DEBUG COMPLETO DO DANO:");
show_debug_message("   - Dano do projétil: " + string(dano));
show_debug_message("   - Alvo: " + string(alvo));
show_debug_message("   - Tipo do alvo: " + string(object_get_name(alvo.object_index)));
```

### **2. Verificação de Variáveis de Vida**
Debug das variáveis de vida do alvo:
```gml
show_debug_message("🔍 Verificando variáveis de vida do alvo...");
show_debug_message("   - hp_atual existe: " + string(variable_instance_exists(alvo, "hp_atual")));
show_debug_message("   - hp existe: " + string(variable_instance_exists(alvo, "hp")));
show_debug_message("   - vida existe: " + string(variable_instance_exists(alvo, "vida")));
```

### **3. Valores Atuais das Variáveis**
Mostra os valores atuais antes de aplicar o dano:
```gml
if (variable_instance_exists(alvo, "vida")) {
    show_debug_message("   - vida atual: " + string(alvo.vida));
}
```

### **4. Debug do Projétil em Voo**
Adicionado dano no debug do projétil:
```gml
show_debug_message("🎯 Alvo: " + string(alvo) + " | Velocidade: " + string(speed) + " | Dano: " + string(dano) + " | Ângulo: " + string(image_angle) + "°");
```

## 🧪 **Como Testar**

1. **Coloque uma lancha próxima a um inimigo**
2. **Aguarde a lancha atirar**
3. **Observe o console de debug** e procure por:
   - `🚀 Tiro em voo` - mostra o dano do projétil
   - `💥 TIRO ACERTOU O ALVO!` - confirma a colisão
   - `🔍 DEBUG COMPLETO DO DANO:` - mostra informações do dano
   - `🎯 Dano aplicado na VIDA!` - confirma aplicação do dano

## 🔍 **Possíveis Causas do Problema**

### **1. Variável `dano` não definida**
- O projétil pode não ter a variável `dano` definida
- Verificar se `dano = 30` está sendo aplicado

### **2. Alvo não tem variável `vida`**
- O inimigo pode não ter a variável `vida` definida
- Verificar se `obj_inimigo` tem `vida = 500`

### **3. Problema de timing**
- O dano pode estar sendo aplicado mas a barra de vida não está atualizando
- Verificar se o `Draw_0.gml` do inimigo está funcionando

### **4. Problema de referência**
- O alvo pode estar sendo perdido entre frames
- Verificar se `instance_exists(alvo)` retorna true

## 📊 **Informações Esperadas no Debug**

Quando funcionando corretamente, você deve ver:
```
🚀 Tiro em voo - Dano: 30
💥 TIRO ACERTOU O ALVO! Distância: 15 <= 25
🔍 DEBUG COMPLETO DO DANO:
   - Dano do projétil: 30
   - Alvo: 100001
   - Tipo do alvo: obj_inimigo
🔍 Verificando variáveis de vida do alvo...
   - vida existe: true
   - vida atual: 500
🎯 Dano aplicado na VIDA! Vida: 500 → 470
✅ DANO APLICADO COM SUCESSO!
```

## 🎯 **Próximos Passos**

1. **Execute o jogo** e observe o console
2. **Identifique onde o processo falha** baseado nas mensagens de debug
3. **Reporte as mensagens** que aparecem no console
4. **Corrija o problema** baseado na informação coletada
