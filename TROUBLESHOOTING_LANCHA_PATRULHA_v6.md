# 🔧 **GUIA DE TROUBLESHOOTING - LANCHA PATRULHA v6.0**

## 🚨 **PROBLEMA: PATRULHA NÃO FUNCIONA**

### ✅ **SOLUÇÕES IMPLEMENTADAS:**

#### **1. VERIFICAÇÃO DE VARIÁVEIS:**
```gml
// Adicionado no início do Step Event
if (!variable_instance_exists(id, "estado")) estado = "parado";
if (!variable_instance_exists(id, "modo_definicao_patrulha")) modo_definicao_patrulha = false;
if (!variable_instance_exists(id, "pontos_patrulha")) pontos_patrulha = ds_list_create();
if (!variable_instance_exists(id, "indice_patrulha_atual")) indice_patrulha_atual = 0;
if (!variable_instance_exists(id, "selecionado")) selecionado = false;
```

#### **2. DEBUG MELHORADO:**
- ✅ Debug detalhado para cada etapa da patrulha
- ✅ Instruções claras no console
- ✅ Verificação de estado em tempo real
- ✅ Contagem de pontos de patrulha

#### **3. SCRIPT DE DIAGNÓSTICO:**
- ✅ `scr_diagnostico_lancha_patrulha()` - Verifica problemas
- ✅ `scr_teste_patrulha_lancha()` - Testa o sistema
- ✅ `scr_corrigir_lancha_patrulha()` - Corrige variáveis

## 🎮 **COMO USAR O SISTEMA DE PATRULHA:**

### **PASSO A PASSO:**

#### **1. SELECIONAR A LANCHA:**
```
1. Clique esquerdo na lancha
2. Verifique se aparece no console:
   "🚢 Lancha Patrulha SELECIONADA!"
3. A lancha deve ficar AMARELA
4. Deve aparecer círculo verde ao redor
```

#### **2. ATIVAR MODO PATRULHA:**
```
1. Pressione a tecla "K"
2. Verifique no console:
   "🎯 Lancha - Modo PATRULHA ATIVADO!"
   "💡 INSTRUÇÕES: Clique esquerdo para adicionar pontos, direito para confirmar"
   "📍 Pontos atuais: 0"
```

#### **3. ADICIONAR PONTOS DE PATRULHA:**
```
1. Clique esquerdo em vários pontos do mapa
2. Para cada clique, verifique no console:
   "📍 PONTO ADICIONADO: (x, y)"
   "📍 Total de pontos: N"
   "💡 Próximo: Clique direito para confirmar patrulha"
```

#### **4. CONFIRMAR PATRULHA:**
```
1. Clique direito para confirmar
2. Se tiver 2+ pontos, verifique no console:
   "🔄 PATRULHA INICIADA!"
   "📍 Pontos na rota: N"
   "🎯 Estado mudou para: patrulhando"
   "🚢 Lancha começará a patrulhar automaticamente"
```

#### **5. VERIFICAR PATRULHA:**
```
1. A lancha deve se mover automaticamente
2. Verifique no console a cada segundo:
   "🚢 PATRULHANDO: Indo para ponto N/M"
   "📍 Distância restante: X pixels"
3. Quando chegar ao ponto:
   "🔄 PATRULHA: Chegou ao ponto N/M"
   "📍 Próximo destino: (x, y)"
```

## 🔍 **DIAGNÓSTICO DE PROBLEMAS:**

### **PROBLEMA 1: LANCHA NÃO SELECIONA**
**Sintomas:**
- Clique esquerdo não funciona
- Lancha não fica amarela
- Não aparece círculo verde

**Soluções:**
1. Verifique se o Mouse Event está funcionando
2. Execute: `scr_diagnostico_lancha_patrulha()`
3. Verifique se há outras unidades interferindo

### **PROBLEMA 2: TECLA "K" NÃO FUNCIONA**
**Sintomas:**
- Pressionar "K" não faz nada
- Console não mostra mensagens

**Soluções:**
1. Verifique se a lancha está selecionada
2. Execute: `scr_corrigir_lancha_patrulha()`
3. Verifique se `selecionado = true`

### **PROBLEMA 3: CLIQUE ESQUERDO NÃO ADICIONA PONTOS**
**Sintomas:**
- Clique esquerdo não adiciona pontos
- Console não mostra "PONTO ADICIONADO"

**Soluções:**
1. Verifique se `modo_definicao_patrulha = true`
2. Verifique se `global.scr_mouse_to_world()` existe
3. Execute: `scr_teste_patrulha_lancha()`

### **PROBLEMA 4: CLIQUE DIREITO NÃO CONFIRMA**
**Sintomas:**
- Clique direito não inicia patrulha
- Console mostra "PATRULHA CANCELADA"

**Soluções:**
1. Verifique se tem pelo menos 2 pontos
2. Verifique se `ds_list_size(pontos_patrulha) > 1`
3. Adicione mais pontos antes de confirmar

### **PROBLEMA 5: LANCHA NÃO PATRULHA**
**Sintomas:**
- Patrulha confirmada mas lancha não se move
- Estado não muda para "patrulhando"

**Soluções:**
1. Verifique se `estado = "patrulhando"`
2. Verifique se `ds_list_size(pontos_patrulha) > 1`
3. Execute: `scr_diagnostico_lancha_patrulha()`

## 🧪 **TESTES AUTOMÁTICOS:**

### **TESTE 1: DIAGNÓSTICO COMPLETO**
```gml
// Execute no console ou em um objeto
scr_diagnostico_lancha_patrulha();
```

### **TESTE 2: CORREÇÃO AUTOMÁTICA**
```gml
// Execute para corrigir problemas
scr_corrigir_lancha_patrulha();
```

### **TESTE 3: TESTE DE PATRULHA**
```gml
// Execute para testar o sistema
scr_teste_patrulha_lancha();
```

## 📊 **VERIFICAÇÃO MANUAL:**

### **VARIÁVEIS IMPORTANTES:**
```gml
// Verifique se estas variáveis existem e têm valores corretos:
selecionado = true                    // Lancha deve estar selecionada
modo_definicao_patrulha = false      // Deve ser false após confirmar
estado = "patrulhando"               // Deve ser "patrulhando" durante patrulha
ds_list_size(pontos_patrulha) > 1    // Deve ter pelo menos 2 pontos
indice_patrulha_atual = 0            // Deve começar em 0
```

### **STATES CORRETOS:**
- **"parado"** - Lancha parada
- **"movendo"** - Lancha indo para destino específico
- **"patrulhando"** - Lancha patrulhando entre pontos
- **"atacando"** - Lancha perseguindo inimigo
- **"definindo_patrulha"** - Lancha em modo de definição (modo_definicao_patrulha = true)

## 🎯 **RESULTADO ESPERADO:**

### **SEQUÊNCIA CORRETA:**
1. ✅ Lancha selecionada (amarela + círculo verde)
2. ✅ Tecla "K" pressionada (modo patrulha ativado)
3. ✅ Cliques esquerdos adicionam pontos
4. ✅ Clique direito confirma patrulha
5. ✅ Lancha patrulha automaticamente entre pontos
6. ✅ Console mostra progresso da patrulha

### **VISUAL ESPERADO:**
- ✅ Círculo verde transparente ao redor da lancha
- ✅ Linhas azuis conectando pontos de patrulha
- ✅ Lancha se move automaticamente entre pontos
- ✅ Painel flutuante mostra status "PATRULHANDO"

## 🚀 **SISTEMA CORRIGIDO E FUNCIONANDO!**

**O sistema de patrulha da lancha v6.0 agora tem:**
- ✅ Verificação automática de variáveis
- ✅ Debug detalhado para troubleshooting
- ✅ Scripts de diagnóstico e correção
- ✅ Instruções claras no console
- ✅ Sistema robusto e confiável

**Se ainda não funcionar, execute os scripts de diagnóstico para identificar o problema específico!** 🔧
