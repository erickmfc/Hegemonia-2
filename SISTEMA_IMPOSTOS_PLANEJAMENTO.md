# 💰 SISTEMA DE IMPOSTOS - PLANEJAMENTO FUTURO

## 📋 Visão Geral

O Sistema de Impostos será a principal fonte de renda contínua da nação, criando um ciclo econômico dinâmico onde:
- **População** gera **atividade econômica**
- **Atividade econômica** gera **impostos**
- **Impostos** financiam **construções e expansão**
- **Expansão** atrai **mais população**

---

## 🎯 Objetivos do Sistema

### 1. **Fluxo de Caixa Contínuo**
- Eliminar dependência apenas do capital inicial
- Criar renda passiva baseada na população
- Incentivar crescimento populacional

### 2. **Estratégia Econômica**
- Permitir ajuste de taxas de impostos
- Criar trade-offs entre arrecadação e satisfação popular
- Conectar economia com política

### 3. **Gameplay Dinâmico**
- Tornar a gestão de recursos mais estratégica
- Criar decisões econômicas interessantes
- Adicionar profundidade ao sistema econômico

---

## 🔧 Implementação Técnica

### **Variáveis Globais (Comentadas)**
```gml
// === SISTEMA DE IMPOSTOS (FUTURO) ===
// global.taxa_impostos = 0.20; // Taxa de 20% de impostos
// global.base_economica_por_cidadao = 10; // 10 CG por cidadão/mês
// global.ultima_coleta_impostos = 0; // Timer da última coleta
// global.ciclo_impostos = 1800; // Coleta a cada 30 segundos
```

### **Lógica de Coleta (Comentada)**
```gml
// === SISTEMA DE IMPOSTOS (FUTURO) ===
// TODO: Implementar coleta de impostos mensal
// if (global.game_frame % (room_speed * 1800) == 0) {
//     var base_economica = global.populacao * global.base_economica_por_cidadao;
//     var impostos_coletados = base_economica * global.taxa_impostos;
//     global.dinheiro += impostos_coletados;
//     show_debug_message("💰 IMPOSTOS: " + string(impostos_coletados) + " CG");
// }
```

---

## 📊 Mecânicas Planejadas

### **1. Cálculo de Impostos**
- **Base:** População × Atividade Econômica por Cidadão
- **Taxa:** Percentual configurável (padrão: 20%)
- **Frequência:** A cada 30 segundos de jogo

### **2. Políticas Econômicas**
- **Taxa Baixa (10%):** Menos arrecadação, população mais feliz
- **Taxa Média (20%):** Equilíbrio entre arrecadação e satisfação
- **Taxa Alta (30%):** Mais arrecadação, risco de instabilidade

### **3. Consequências**
- **Alta Taxa:** Pode reduzir crescimento populacional
- **Baixa Taxa:** Menos recursos para investimentos
- **Instabilidade:** Taxas muito altas causam revoltas

---

## 🎮 Impacto no Gameplay

### **Estratégia de Crescimento**
1. **Construir Fazendas** → Mais Alimento
2. **Alimentar População** → Crescimento Demográfico
3. **Mais População** → Mais Atividade Econômica
4. **Mais Atividade** → Mais Impostos
5. **Mais Impostos** → Mais Investimentos

### **Decisões Econômicas**
- **Investir em Alimento** vs **Investir em Indústria**
- **Taxa de Impostos** vs **Satisfação Popular**
- **Crescimento Rápido** vs **Estabilidade**

---

## 🚀 Fases de Implementação

### **Fase 1: Base (Atual)**
- ✅ Sistema comentado implementado
- ✅ Variáveis preparadas
- ✅ Lógica documentada
- ⏳ Aguardando ativação

### **Fase 2: Ativação**
- 🔄 Descomentar variáveis
- 🔄 Ativar lógica de coleta
- 🔄 Testar sistema básico
- 🔄 Ajustar balanceamento

### **Fase 3: Expansão**
- 🔄 Interface de política fiscal
- 🔄 Consequências de alta/baixa taxa
- 🔄 Eventos econômicos especiais
- 🔄 Sistema de satisfação popular

### **Fase 4: Avançado**
- 🔄 Impostos por setor (agricultura, indústria, comércio)
- 🔄 Políticas fiscais sazonais
- 🔄 Acordos comerciais
- 🔄 Sistema de dívida pública

---

## 📈 Balanceamento

### **Valores Iniciais Sugeridos**
- **Taxa de Impostos:** 20% (equilibrada)
- **Atividade por Cidadão:** 10 CG/mês
- **Frequência de Coleta:** 30 segundos
- **Crescimento Populacional:** 1% por ciclo (se bem alimentada)

### **Cálculos de Exemplo**
- **População:** 2.000 pessoas
- **Atividade Total:** 2.000 × 10 = 20.000 CG/mês
- **Impostos (20%):** 20.000 × 0.20 = 4.000 CG/mês
- **Renda Anual:** 4.000 × 12 = 48.000 CG/ano

---

## 🔮 Expansões Futuras

### **Sistema de Setores**
- **Agricultura:** Taxa baixa, população rural
- **Indústria:** Taxa média, alta produtividade
- **Comércio:** Taxa alta, renda variável

### **Eventos Econômicos**
- **Boom Econômico:** +50% atividade por 1 mês
- **Recessão:** -30% atividade por 2 meses
- **Crise Fiscal:** Necessidade de empréstimos

### **Políticas Avançadas**
- **Imposto Progressivo:** Maior renda = maior taxa
- **Isenções Fiscais:** Incentivos para setores específicos
- **Acordos Comerciais:** Comércio com outras nações

---

## 📝 Status Atual

**Status:** ✅ **PREPARADO PARA IMPLEMENTAÇÃO**

- ✅ Código comentado implementado
- ✅ Documentação completa
- ✅ Estrutura preparada
- ⏳ Aguardando decisão para ativação

---

## 🎯 Próximos Passos

1. **Testar Sistema Atual** - Verificar se Casa da Moeda funciona
2. **Decidir Ativação** - Quando implementar impostos
3. **Balanceamento** - Ajustar valores para gameplay
4. **Interface** - Criar UI para política fiscal
5. **Expansão** - Adicionar mecânicas avançadas

---

**Data do Planejamento:** 22 de Outubro de 2025  
**Status:** ✅ **Sistema Preparado e Documentado**

🎉 **O sistema de impostos está pronto para ser ativado quando necessário!**
