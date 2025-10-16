<!-- a4a5ee02-6770-4c54-b420-ebd5f127ad10 ba559359-cacd-48a0-9e83-48d1ecb982ce -->
# Plano: Sistema de Efeitos Visuais com Partículas para Mísseis

## Objetivo

Criar um sistema completo de efeitos visuais profissionais usando partículas do GameMaker para os mísseis SkyFury_ar (ar-ar) e Ironclad_terra (ar-terra), com explosões diferenciadas, trilhas realistas e integração completa.

## Escopo da Implementação

### 1. **Objeto: obj_fumaca_missil (Trilha de Fumaça)**

- Sistema de partículas contínuo
- Fumaça realista com 3 tons de cinza
- Alpha decrescente (0.6 → 0)
- Gravidade sutil para movimento natural
- Auto-destruição após 1 segundo

### 2. **Objeto: obj_explosao_terra (Explosão Terrestre)**

- 3 tipos de partículas: fogo, poeira, detritos
- Fogo: vermelho/amarelo com blend aditivo
- Poeira: marrom com dispersão
- Detritos: pedaços com física realista
- Flash de luz integrado
- Som de explosão

### 3. **Objeto: obj_explosao_ar (Explosão Aérea)**

- 3 tipos de partículas: chamas, faíscas, fumaça
- Chamas: cores vibrantes com blend aditivo
- Faíscas: pixels brilhantes dispersos
- Fumaça: nuvens expansivas
- Flash de luz integrado
- Som de explosão

### 4. **Objeto: obj_rastro_fogo (Motor do Míssil)**

- Partículas de fogo contínuas
- Cores quentes (vermelho/amarelo)
- Blend aditivo para brilho
- Intensidade variável
- Auto-destruição após 0.5 segundos

### 5. **Integração com SkyFury_ar**

- Atribuir efeitos específicos para ar
- Configurar explosão aérea
- Ativar trilha de fumaça
- Ativar rastro de motor
- Cor azul clara característica

### 6. **Integração com Ironclad_terra**

- Atribuir efeitos específicos para terra
- Configurar explosão terrestre
- Ativar trilha de fumaça
- Ativar rastro de motor
- Cor laranja característica

## Arquivos a Criar

### **objects/obj_fumaca_missil/**

- `Create_0.gml` - Sistema de partículas e configuração
- `Step_0.gml` - Geração contínua de fumaça
- `Destroy_0.gml` - Limpeza do sistema

### **objects/obj_explosao_terra/**

- `Create_0.gml` - 3 tipos de partículas + som + flash
- `Alarm_0.gml` - Auto-destruição
- `Destroy_0.gml` - Limpeza completa

### **objects/obj_explosao_ar/**

- `Create_0.gml` - 3 tipos de partículas + som + flash
- `Alarm_0.gml` - Auto-destruição
- `Destroy_0.gml` - Limpeza completa

### **objects/obj_rastro_fogo/**

- `Create_0.gml` - Sistema de partículas de fogo
- `Step_0.gml` - Geração contínua de fogo
- `Destroy_0.gml` - Limpeza do sistema

## Arquivos a Modificar

### **objects/SkyFury_ar/Create_0.gml**

- Adicionar referências aos efeitos visuais
- Configurar efeito_explosao = obj_explosao_ar
- Configurar efeito_trilha = obj_fumaca_missil
- Configurar efeito_motor = obj_rastro_fogo
- Adicionar cor característica azul

### **objects/Ironclad_terra/Create_0.gml**

- Adicionar referências aos efeitos visuais
- Configurar efeito_explosao = obj_explosao_terra
- Configurar efeito_trilha = obj_fumaca_missil
- Configurar efeito_motor = obj_rastro_fogo
- Adicionar cor característica laranja

## Características Técnicas

### **Sistema de Partículas**

- Usar `part_system_create()` para cada objeto
- Configurar depth apropriado
- Usar `part_type_create()` para cada tipo
- Configurar cores com `make_color_rgb()`
- Usar blend aditivo para efeitos de luz

### **Tipos de Partículas Disponíveis**

- `pt_shape_cloud` - para fumaça
- `pt_shape_flare` - para fogo/chamas
- `pt_shape_smoke` - para poeira
- `pt_shape_pixel` - para detritos/faíscas

### **Configurações de Partículas**

- Size: tamanho min/max
- Color: até 3 cores de transição
- Alpha: até 3 níveis de transparência
- Life: tempo de vida em frames
- Speed: velocidade min/max
- Direction: direção em graus
- Gravity: força e direção da gravidade
- Blend: modo de mistura

### **Limpeza Automática**

- Sempre destruir tipos de partículas no Destroy
- Sempre destruir sistemas de partículas no Destroy
- Usar timers para auto-destruição dos objetos
- Evitar memory leaks

## Resultado Esperado

Um sistema completo de efeitos visuais profissionais que proporciona:

- Trilhas realistas de fumaça atrás dos mísseis
- Rastros de fogo do motor visíveis
- Explosões diferenciadas e impressionantes (ar vs terra)
- Flash de luz no impacto
- Som sincronizado
- Performance otimizada com limpeza automática
- Visual cinematográfico e realista

### To-dos

- [ ] Criar obj_fumaca_missil com sistema de partículas de fumaça
- [ ] Criar obj_explosao_terra com fogo, poeira e detritos
- [ ] Criar obj_explosao_ar com chamas, faíscas e fumaça
- [ ] Criar obj_rastro_fogo com partículas de motor
- [ ] Integrar efeitos visuais no SkyFury_ar
- [ ] Integrar efeitos visuais no Ironclad_terra
- [ ] Testar todos os efeitos visuais e ajustar parâmetros
- [ ] revisa se ta tudo certo codigos nosvos compativeis com glm 