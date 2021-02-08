bpm = 126

live_loop :metro do
  use_bpm bpm
  sleep 4
end

set_mixer_control! hpf: 0, hpf_slide: 4
set_mixer_control! lpf: 130, lpf_slide: 2
set_mixer_control! amp: 1, amp_slide: 2

with_fx :reverb, room: 0.8 do
  live_loop :ground, sync: :metro do
    
    tick
    use_random_seed rrand(0, 999)
    use_bpm bpm
    
    ##| stop
    32.times do
      cp = ['e3', 'b3', 'a3', 'e3'].look
      puts cp
      sc = ['minor', 'minor_pentatonic', 'minor_pentatonic', 'minor_pentatonic'].look
      
      
      n = [0,0,7,0].look
      n2 = [0,1,2,5,7].shuffle.look
      
      notes = scale(cp, sc).shuffle.tick(:notes)
      notes2 = scale(cp, sc).shuffle.tick(:notes2)
      notes3 = scale(cp, sc)[n]
      notes4 = scale(cp, sc)[n2]
      
      num = rrand_i(1, 64)
      num2 = rrand_i(1,64)
      num3 = rrand_i(1,64)
      
      if one_in(2)
        with_fx :distortion, amp: 0.5, distort: 0.3 do
          with_fx :eq, high: 0.2 do
            if spread(num,num2).rotate(num3).tick(:fm1)
              synth :fm,
                note: notes2+12,
                depth: 1,
                divisor: 1,
                attack: 0.01,
                amp: 0.5,
                release: 0.25
            end
          end
        end
      end
      
      with_fx :lpf, cutoff: 80 do
        if spread(32, num2).rotate(num3).tick(:b1)
          synth :tb303,
            note: notes3 -12,
            ##| depth: 1,
            ##| divisor: 1,
            res: (range 0, 0.6, 0.05).mirror.look(:b1),
            cutoff: (range 50, 130, 1).mirror.look(:b1),
            attack: 0.02,
            amp: 1,
            release: 0.25
        end
      end
      
      sleep 0.25
    end
    # stop
  end
end




with_fx :reverb, room: 1, mix: 0.5 do
  live_loop :chords, sync: :metro do
    ##| stop
    use_bpm bpm
    tick
    
    cp = ['e2', 'b2', 'a2', 'e2'].look
    tone = ['m', 'm', 'm7', 'm7'].look
    sc = get[:sc]
    
    notes = chord(cp, tone, num_octaves: 4, chord_invert: 1)
    n = 8
    ##| if one_in(1)
    with_fx :lpf, cutoff: 100 do
      with_fx :slicer, phase: [0.75].choose do
        with_fx :ixi_techno, phase: dice(8) do
          synth :fm,
            amp: 0.8,
            depth: 0,
            attack: 0,
            note: notes,
            release: n,
            sustain: n*0.9
        end
      end
    end
    sleep n
  end
end

with_fx :reverb, room: 0.3 do
  live_loop :bd, sync: :metro do
    
    ##| stop
    use_bpm bpm
    
    with_fx :bpf, centre: 50, res: 0.1 do
      with_fx :eq, amp: 3, low: 0.6, mid: 0.8, high: 0 do
        sample :bd_tek, amp: 1, rate: 1 if spread(1,4).tick
        ##| sam,amp: 4, sustain: 0.25, rate: 1 if spread(1,16).rotate(5).look
      end
    end
    ##| stop
    sleep 0.25
  end
end

with_fx :reverb, room: 0.1 do
  live_loop :pc, sync: :metro do
    ##| stop
    use_bpm bpm
    tick
    with_fx :lpf, cutoff: 100 do
      with_fx :bpf, centre: 120, res: 0.3 do
        with_fx :eq, amp: 2,low: 0, high: 0.2, mid: 0.3 do
          sample :drum_cymbal_pedal, amp: 1.5,  release: 0.1 if spread(3,16).rotate(4).look
          sample :drum_cymbal_closed, amp: 1 if spread(1,4).rotate(2).look
        end
      end
      
      sleep 0.25
    end
  end
end







