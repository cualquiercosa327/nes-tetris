p1_to_zeropage:
  LDX #$C8
.loop:
  LDA player1, X
  STA <$00, X
  INX
  BNE .loop

  LDA #LOW(player1)
  STA <playfield_addr
  LDA #HIGH(player1)
  STA <playfield_addr+1
  LDA #0
  STA <draw_10_offset
  STA <draw_4_offset
  STA <draw_5_offset
  STA <oam_offset
  LDA #2
  STA <sprite_palette

  RTS

zeropage_to_p1:
  LDX #$C8
.loop:
  LDA <$00, X
  STA player1, X
  INX
  BNE .loop

  RTS

p2_to_zeropage:
  LDX #$C8
.loop:
  LDA player2, X
  STA <$00, X
  INX
  BNE .loop

  LDA #LOW(player2)
  STA <playfield_addr
  LDA #HIGH(player2)
  STA <playfield_addr+1
  LDA #draw_10_5 - draw_10_0
  STA <draw_10_offset
  LDA #draw_4_3 - draw_4_0
  STA <draw_4_offset
  LDA #draw_5_1 - draw_5_0
  STA <draw_5_offset
  LDA #$20
  STA <oam_offset
  LDA #3
  STA <sprite_palette

  RTS

zeropage_to_p2:
  LDX #$C8
.loop:
  LDA <$00, X
  STA player2, X
  INX
  BNE .loop

  RTS

to_sprint_1_state:
  ppumem NAMETABLE1
  LDA #LOW(player1_screen)
  STA <$00
  LDA #HIGH(player1_screen)
  STA <$01
  JSR blit

  JSR game_init

  LDA #S_SPRINT_1
  STA <game_state

  JMP frame_end

to_marathon_1_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

to_ultra_1_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

to_battle_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

to_sprint_2_state:
  ppumem NAMETABLE1
  LDA #LOW(player2_screen)
  STA <$00
  LDA #HIGH(player2_screen)
  STA <$01
  JSR blit

  JSR game_init

  LDA #S_SPRINT_2
  STA <game_state

  JMP frame_end

to_marathon_2_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

to_ultra_2_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

sprint_1_state:
  JSR draw
  ; reset camera location & enable rendering
  LDA #$00
  STA PPUSCROLL
  STA PPUSCROLL

  LDA #PPU_ENABLE | PPU_SPRITES
  STA PPUMASK

  JSR clear_draw
  JSR read_input
  
  JSR p1_to_zeropage
  LDA #$0A
  STA <ppu_offset
  JSR p_update
  JSR zeropage_to_p1

  JMP frame_end

marathon_1_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

ultra_1_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

battle_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

sprint_2_state:
  JSR draw
  ; reset camera location & enable rendering
  LDA #$00
  STA PPUSCROLL
  STA PPUSCROLL

  LDA #PPU_ENABLE | PPU_SPRITES
  STA PPUMASK

  JSR clear_draw
  JSR read_input
  
  JSR p1_to_zeropage
  LDA #$01
  STA <ppu_offset
  JSR p_update
  JSR zeropage_to_p1
  
  JSR p2_to_zeropage
  LDA #$10
  STA <ppu_offset
  JSR p_update
  JSR zeropage_to_p2

  JMP frame_end

marathon_2_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end

ultra_2_state:
  LDA #S_TO_ABOUT
  STA <game_state
  JMP frame_end
