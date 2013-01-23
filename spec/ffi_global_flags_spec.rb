require 'spec_helper'

module LAME
  describe "FFI calls to global flags" do

    before do
      @flags_pointer = LAME.lame_init
    end

    after do
      LAME.lame_close(@flags_pointer)
    end

    def test_get(flag, expected_value)
      LAME.send(:"lame_get_#{flag}", @flags_pointer).should eql expected_value
    end

    def test_get_float(flag, expected_value)
      LAME.send(:"lame_get_#{flag}", @flags_pointer).should be_within(0.00001).of(expected_value)
    end

    def test_set(flag, new_value, return_value = 0)
      LAME.send(:"lame_set_#{flag}", @flags_pointer, new_value).should eql return_value
      test_get(flag, new_value)
    end

    def test_set_float(flag, new_value, return_value = 0)
      LAME.send(:"lame_set_#{flag}", @flags_pointer, new_value).should eql return_value
      test_get_float(flag, new_value)
    end

    context "global flags" do

      before do
        LAME.lame_init_params(@flags_pointer)
      end

      it "has a number of samples" do
        test_get(:num_samples, 2**32-1)
        test_set(:num_samples, 1)
      end

      it "has an input samplerate" do
        test_get(:in_samplerate, 44100)
        test_set(:in_samplerate, 22050)
      end

      it "has a number of channels" do
        test_get(:num_channels, 2)
        test_set(:num_channels, 1)
      end

      it "has a scale" do
        test_get_float(:scale, 0.95)
        test_set_float(:scale, 2.0)
      end

      it "has a scale_left" do
        test_get(:scale_left, 1.0)
        test_set(:scale_left, 2.0)
      end

      it "has a scale_right" do
        test_get(:scale_right, 1.0)
        test_set(:scale_right, 2.0)
      end

      it "has a output samplerate" do
        test_get(:out_samplerate, 44100)
        test_set(:out_samplerate, 48000)
      end

      it "has an analysis" do
        test_get(:analysis, 0)
        test_set(:analysis, 1)
      end

      it "has bWriteVbrTag" do
        test_get(:bWriteVbrTag, 1)
        test_set(:bWriteVbrTag, 0)
      end

      it "has decode only" do
        test_get(:decode_only, 0)
        test_set(:decode_only, 1)
      end

      it "has a quality" do
        test_get(:quality, 3)
        test_set(:quality, 1)
      end

      it "has a mode" do
        test_get(:mode, 1)
        test_set(:mode, 2)
      end

      it "has force ms" do
        test_get(:force_ms, 0)
        test_set(:force_ms, 1)
      end

      it "has free format" do
        test_get(:free_format, 0)
        test_set(:free_format, 1)
      end

      it "has find replay gain" do
        test_get(:findReplayGain, 0)
        test_set(:findReplayGain, 1)
      end

      it "has decode on the fly" do
        test_get(:decode_on_the_fly, 0)
        test_set(:decode_on_the_fly, 1)
      end

      it "has nogap total" do
        test_get(:nogap_total, 0)
        test_set(:nogap_total, 1)
      end

      it "has nogap current index" do
        test_get(:nogap_currentindex, 0)
        test_set(:nogap_currentindex, 1)
      end

      # TODO:
      it "sets errorf"
      it "sets debugf"
      it "sets msgf"

      it "has a brate" do
        test_get(:brate, 128)
        test_set(:brate, 192)
      end

      it "has a compression ratio" do
        test_get(:compression_ratio, 1)
        #test_set(:compression_ratio, 11.025) # can't set it..?
      end

      it "has a preset" do
        LAME.lame_set_preset(@flags_pointer, 500).should eql 500
      end

      it "sets asm optimizations" do
        LAME.lame_set_asm_optimizations(@flags_pointer, 1, 2).should eql 1
      end

      it "has a copyright mark" do
        test_get(:copyright, 0)
        test_set(:copyright, 1)
      end

      it "has an original mark" do
        test_get(:original, 1)
        test_set(:original, 0)
      end

      it "has error protection" do
        test_get(:error_protection, 0)
        test_set(:error_protection, 1)
      end

      it "has extension mark" do
        test_get(:extension, 0)
        test_set(:extension, 1)
      end

      it "has strict ISO" do
        test_get(:strict_ISO, 2) # ?
        test_set(:strict_ISO, 1)
      end


      context "quantization/noise shaping" do

        it "has disable reservoir" do
          test_get(:disable_reservoir, 0)
          test_set(:disable_reservoir, 1)
        end

        it "has quant comp" do
          test_get(:quant_comp, 9)
          test_set(:quant_comp, 11)
        end

        it "has quant comp short" do
          test_get(:quant_comp_short, 9)
          test_set(:quant_comp_short, 11)
        end

        it "has experimentalX" do
          test_get(:experimentalX, 9)
          test_set(:experimentalX, 11)
        end

        it "has experimentalY" do
          test_get(:experimentalY, 0)
          test_set(:experimentalY, 1)
        end

        it "has experimentalZ" do
          test_get(:experimentalZ, 0)
          test_set(:experimentalZ, 1)
        end

        it "has exp nspsytune" do
          test_get(:exp_nspsytune, 1)
          test_set(:exp_nspsytune, 0)
        end

        it "has msfix" do
          test_get_float(:msfix, 1.95)
          test_set_float(:msfix, 1.55, nil)
        end
      end

      context "VBR" do
        it "has VBR mode" do
          test_get(:VBR, :vbr_off)
          test_set(:VBR, :vbr_mt)
        end

        it "has VBR q" do
          test_get(:VBR_q, 4)
          test_set(:VBR_q, 5)
        end

        it "has VBR quality" do
          test_get_float(:VBR_quality, 4.0)
          test_set_float(:VBR_quality, 5.0)
        end

        it "has VBR mean bitrate kbps" do
          test_get(:VBR_mean_bitrate_kbps, 128)
          test_set(:VBR_mean_bitrate_kbps, 192)
        end

        it "has VBR min bitrate kbps" do
          test_get(:VBR_min_bitrate_kbps, 0)
          test_set(:VBR_min_bitrate_kbps, 128)
        end

        it "has VBR max bitrate kbps" do
          test_get(:VBR_max_bitrate_kbps, 0)
          test_set(:VBR_max_bitrate_kbps, 256)
        end

        it "has VBR hard min bitrate kbps" do
          test_get(:VBR_hard_min, 0)
          test_set(:VBR_hard_min, 1)
        end
      end

      context "filtering control" do
        it "has lowpassfreq" do
          test_get(:lowpassfreq, 17000)
          test_set(:lowpassfreq, 18000)
        end

        it "has lowpasswidth" do
          test_get(:lowpasswidth, -1)
          test_set(:lowpasswidth, 200)
        end

        it "has highpassfreq" do
          test_get(:highpassfreq, 0)
          test_set(:highpassfreq, -1)
        end

        it "has highpasswidth" do
          test_get(:highpasswidth, -1)
          test_set(:highpasswidth, 200)
        end
      end

      context "psycho acoustics" do
        it "has ATHonly" do
          test_get(:ATHonly, 0)
          test_set(:ATHonly, 1)
        end

        it "has ATHshort" do
          test_get(:ATHshort, 0)
          test_set(:ATHshort, 1)
        end

        it "has noATH" do
          test_get(:noATH, 0)
          test_set(:noATH, 1)
        end

        it "has ATHtype" do
          test_get(:ATHtype, 4)
          test_set(:ATHtype, 5)
        end

        it "has ATHlower" do
          test_get_float(:ATHlower, 3.0)
          test_set_float(:ATHlower, 4.0)
        end

        it "has athaa type" do
          test_get(:athaa_type, -1)
          test_set(:athaa_type, 1)
        end

        it "has athaa sensitivity" do
          test_get_float(:athaa_sensitivity, 0.0)
          test_set_float(:athaa_sensitivity, 0.0)
        end
      end

      context "blocks" do
        it "has allow diff short" do
          test_get(:allow_diff_short, 0)
          test_set(:allow_diff_short, 1)
        end

        it "has useTemporal" do
          test_get(:useTemporal, 1)
          test_set(:useTemporal, 0)
        end

        it "has interChRatio" do
          test_get_float(:interChRatio, 0.0002)
          test_set_float(:interChRatio, 0.0003)
        end

        it "has no short blocks" do
          test_get(:no_short_blocks, 0)
          test_set(:no_short_blocks, 1)
        end

        it "has force short blocks" do
          test_get(:force_short_blocks, 0)
          test_set(:force_short_blocks, 1)
        end

        it "has emphasis" do
          test_get(:emphasis, 0)
          test_set(:emphasis, 1)
        end
      end

      context "internal variables" do
        it "has a version" do
          test_get(:version, 1)
        end

        it "has encoder delay" do
          test_get(:encoder_delay, 576)
        end

        it "has encoder padding" do
          test_get(:encoder_padding, 0)
        end

        it "has framesize" do
          test_get(:framesize, 1152)
        end

        it "has mf samples to encode" do
          test_get(:mf_samples_to_encode, 1728)
        end

        # this produces a the 'stange error flushing buffer' warning
        # fix when "set_errorf" works so we can suppress the warning
        xit "has size mp3buffer" do
          test_get(:size_mp3buffer, 834)
        end

        it "has frameNum" do
          test_get(:frameNum, 0)
        end

        it "has totalframes" do
          test_get(:totalframes, 3728272)
        end

        it "has RatioGain" do
          test_get(:RadioGain, 0)
        end

        it "has AudiophileGain" do
          test_get(:AudiophileGain, 0)
        end

        it "has PeakSample" do
          test_get_float(:PeakSample, 0.0)
        end

        it "has noclipGainChange" do
          test_get(:noclipGainChange, 0)
        end

        it "has noclipScale" do
          test_get_float(:noclipScale, -1.0)
        end
      end

      context "version" do
        it "has a version" do
          LAME.get_lame_version.should eql "3.99.5"
        end

        it "has a short version" do
          LAME.get_lame_short_version.should eql "3.99.5"
        end

        it "has a very short version" do
          LAME.get_lame_very_short_version.should eql "LAME3.99r5"
        end

        it "has a psy version" do
          LAME.get_psy_version.should eql "1.0"
        end

        it "has a url" do
          LAME.get_lame_url.should eql "http://lame.sf.net"
        end

        it "has os bitness" do
          LAME.get_lame_os_bitness.should eql "64bits"
        end
      end
    end

  end
end
