require 'spec_helper'

module LAME
  describe GlobalFlags do
    it "initializes LAME" do
      pointer = ::FFI::Pointer.new(0)
      LAME.should_receive(:lame_init).and_return(pointer)
      GlobalFlags.new
    end

    it "closes the LAME struct pointer" do
      pointer = ::FFI::Pointer.new(0)
      LAME.should_receive(:lame_close).with(pointer)
      GlobalFlags.release(pointer)
    end
  end

  describe "FFI calls to global flags" do

    before do
      @flags_pointer = LAME.lame_init
    end

    after do
      LAME.lame_close(@flags_pointer)
    end

    it "sets msgf" do
      callback = ::FFI::Function.new(:void, [:string, :pointer]) do |format, arguments|
        # the :pointer is a va_list, FFI doesn't support that in callbacks..
        # puts format
      end

      LAME.lame_set_msgf(@flags_pointer, callback).should eql 0
      LAME.lame_set_errorf(@flags_pointer, callback).should eql 0
      LAME.lame_set_debugf(@flags_pointer, callback).should eql 0

      LAME.lame_init_params(@flags_pointer)

      LAME.lame_print_config(@flags_pointer)
      LAME.lame_print_internals(@flags_pointer)
    end

    context "global flags" do

      before do
        LAME.lame_init_params(@flags_pointer)
      end

      it "has a number of samples" do
        LAME.should have_flag(:num_samples).with_value(2**32-1).for(@flags_pointer)
        LAME.should be_able_to_set(:num_samples).to(1).for(@flags_pointer)
      end

      it "has an input samplerate" do
        LAME.should have_flag(:in_samplerate).with_value(44100).for(@flags_pointer)
        LAME.should be_able_to_set(:in_samplerate).to(22050).for(@flags_pointer)
      end

      it "has a number of channels" do
        LAME.should have_flag(:num_channels).with_value(2).for(@flags_pointer)
        LAME.should be_able_to_set(:num_channels).to(1).for(@flags_pointer)
      end

      it "has a scale" do
        LAME.should have_flag(:scale).with_value(0.95).for(@flags_pointer)
        LAME.should be_able_to_set(:scale).to(2.0).for(@flags_pointer)
      end

      it "has a scale_left" do
        LAME.should have_flag(:scale_left).with_value(1.0).for(@flags_pointer)
        LAME.should be_able_to_set(:scale_left).to(2.0).for(@flags_pointer)
      end

      it "has a scale_right" do
        LAME.should have_flag(:scale_right).with_value(1.0).for(@flags_pointer)
        LAME.should be_able_to_set(:scale_right).to(2.0).for(@flags_pointer)
      end

      it "has a output samplerate" do
        LAME.should have_flag(:out_samplerate).with_value(44100).for(@flags_pointer)
        LAME.should be_able_to_set(:out_samplerate).to(48000).for(@flags_pointer)
      end

      it "has an analysis" do
        LAME.should have_flag(:analysis).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:analysis).to(1).for(@flags_pointer)
      end

      it "has bWriteVbrTag" do
        LAME.should have_flag(:bWriteVbrTag).with_value(1).for(@flags_pointer)
        LAME.should be_able_to_set(:bWriteVbrTag).to(0).for(@flags_pointer)
      end

      it "has decode only" do
        LAME.should have_flag(:decode_only).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:decode_only).to(1).for(@flags_pointer)
      end

      it "has a quality" do
        LAME.should have_flag(:quality).with_value(3).for(@flags_pointer)
        LAME.should be_able_to_set(:quality).to(1).for(@flags_pointer)
      end

      it "has a mode" do
        LAME.should have_flag(:mode).with_value(:joint_stereo).for(@flags_pointer)
        LAME.should be_able_to_set(:mode).to(:stereo).for(@flags_pointer)
      end

      it "has force ms" do
        LAME.should have_flag(:force_ms).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:force_ms).to(1).for(@flags_pointer)
      end

      it "has free format" do
        LAME.should have_flag(:free_format).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:free_format).to(1).for(@flags_pointer)
      end

      it "has find replay gain" do
        LAME.should have_flag(:findReplayGain).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:findReplayGain).to(1).for(@flags_pointer)
      end

      it "has decode on the fly" do
        LAME.should have_flag(:decode_on_the_fly).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:decode_on_the_fly).to(1).for(@flags_pointer)
      end

      it "has nogap total" do
        LAME.should have_flag(:nogap_total).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:nogap_total).to(1).for(@flags_pointer)
      end

      it "has nogap current index" do
        LAME.should have_flag(:nogap_currentindex).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:nogap_currentindex).to(1).for(@flags_pointer)
      end

      # lame_set_errorf
      # lame_set_debugf
      # lame_set_msgf

      it "has a brate" do
        LAME.should have_flag(:brate).with_value(128).for(@flags_pointer)
        LAME.should be_able_to_set(:brate).to(192).for(@flags_pointer)
      end

      it "has a compression ratio" do
        LAME.should have_flag(:compression_ratio).with_value(1).for(@flags_pointer)
        #LAME.should be_able_to_set(:compression_ratio).to(11.025).for(@flags_pointer) # can't set it..?
      end

      it "has a preset" do
        LAME.lame_set_preset(@flags_pointer, :V0).should eql :V0
      end

      it "sets asm optimizations" do
        LAME.lame_set_asm_optimizations(@flags_pointer, :MMX, 1).should eql :MMX
      end

      it "has a copyright mark" do
        LAME.should have_flag(:copyright).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:copyright).to(1).for(@flags_pointer)
      end

      it "has an original mark" do
        LAME.should have_flag(:original).with_value(1).for(@flags_pointer)
        LAME.should be_able_to_set(:original).to(0).for(@flags_pointer)
      end

      it "has error protection" do
        LAME.should have_flag(:error_protection).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:error_protection).to(1).for(@flags_pointer)
      end

      it "has extension mark" do
        LAME.should have_flag(:extension).with_value(0).for(@flags_pointer)
        LAME.should be_able_to_set(:extension).to(1).for(@flags_pointer)
      end

      it "has strict ISO" do
        LAME.should have_flag(:strict_ISO).with_value(2).for(@flags_pointer) # ?
        LAME.should be_able_to_set(:strict_ISO).to(1).for(@flags_pointer)
      end

      context "quantization/noise shaping" do

        it "has disable reservoir" do
          LAME.should have_flag(:disable_reservoir).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:disable_reservoir).to(1).for(@flags_pointer)
        end

        it "has quant comp" do
          LAME.should have_flag(:quant_comp).with_value(9).for(@flags_pointer)
          LAME.should be_able_to_set(:quant_comp).to(11).for(@flags_pointer)
        end

        it "has quant comp short" do
          LAME.should have_flag(:quant_comp_short).with_value(9).for(@flags_pointer)
          LAME.should be_able_to_set(:quant_comp_short).to(11).for(@flags_pointer)
        end

        it "has experimentalX" do
          LAME.should have_flag(:experimentalX).with_value(9).for(@flags_pointer)
          LAME.should be_able_to_set(:experimentalX).to(11).for(@flags_pointer)
        end

        it "has experimentalY" do
          LAME.should have_flag(:experimentalY).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:experimentalY).to(1).for(@flags_pointer)
        end

        it "has experimentalZ" do
          LAME.should have_flag(:experimentalZ).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:experimentalZ).to(1).for(@flags_pointer)
        end

        it "has exp nspsytune" do
          LAME.should have_flag(:exp_nspsytune).with_value(1).for(@flags_pointer)
          LAME.should be_able_to_set(:exp_nspsytune).to(0).for(@flags_pointer)
        end

        it "has msfix" do
          LAME.should have_flag(:msfix).with_value(1.95).for(@flags_pointer)
          LAME.should be_able_to_set(:msfix).to(1.55).and_return(nil).for(@flags_pointer)
        end
      end

      context "VBR" do
        it "has VBR mode" do
          LAME.should have_flag(:VBR).with_value(:vbr_off).for(@flags_pointer)
          LAME.should be_able_to_set(:VBR).to(:vbr_mt).for(@flags_pointer)
        end

        it "has VBR q" do
          LAME.should have_flag(:VBR_q).with_value(4).for(@flags_pointer)
          LAME.should be_able_to_set(:VBR_q).to(5).for(@flags_pointer)
        end

        it "has VBR quality" do
          LAME.should have_flag(:VBR_quality).with_value(4.0).for(@flags_pointer)
          LAME.should be_able_to_set(:VBR_quality).to(5.0).for(@flags_pointer)
        end

        it "has VBR mean bitrate kbps" do
          LAME.should have_flag(:VBR_mean_bitrate_kbps).with_value(128).for(@flags_pointer)
          LAME.should be_able_to_set(:VBR_mean_bitrate_kbps).to(192).for(@flags_pointer)
        end

        it "has VBR min bitrate kbps" do
          LAME.should have_flag(:VBR_min_bitrate_kbps).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:VBR_min_bitrate_kbps).to(128).for(@flags_pointer)
        end

        it "has VBR max bitrate kbps" do
          LAME.should have_flag(:VBR_max_bitrate_kbps).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:VBR_max_bitrate_kbps).to(256).for(@flags_pointer)
        end

        it "has VBR hard min bitrate kbps" do
          LAME.should have_flag(:VBR_hard_min).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:VBR_hard_min).to(1).for(@flags_pointer)
        end
      end

      context "filtering control" do
        it "has lowpassfreq" do
          LAME.should have_flag(:lowpassfreq).with_value(17000).for(@flags_pointer)
          LAME.should be_able_to_set(:lowpassfreq).to(18000).for(@flags_pointer)
        end

        it "has lowpasswidth" do
          LAME.should have_flag(:lowpasswidth).with_value(-1).for(@flags_pointer)
          LAME.should be_able_to_set(:lowpasswidth).to(200).for(@flags_pointer)
        end

        it "has highpassfreq" do
          LAME.should have_flag(:highpassfreq).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:highpassfreq).to(-1).for(@flags_pointer)
        end

        it "has highpasswidth" do
          LAME.should have_flag(:highpasswidth).with_value(-1).for(@flags_pointer)
          LAME.should be_able_to_set(:highpasswidth).to(200).for(@flags_pointer)
        end
      end

      context "psycho acoustics" do
        it "has ATHonly" do
          LAME.should have_flag(:ATHonly).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:ATHonly).to(1).for(@flags_pointer)
        end

        it "has ATHshort" do
          LAME.should have_flag(:ATHshort).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:ATHshort).to(1).for(@flags_pointer)
        end

        it "has noATH" do
          LAME.should have_flag(:noATH).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:noATH).to(1).for(@flags_pointer)
        end

        it "has ATHtype" do
          LAME.should have_flag(:ATHtype).with_value(4).for(@flags_pointer)
          LAME.should be_able_to_set(:ATHtype).to(5).for(@flags_pointer)
        end

        it "has ATHlower" do
          LAME.should have_flag(:ATHlower).with_value(3.0).for(@flags_pointer)
          LAME.should be_able_to_set(:ATHlower).to(4.0).for(@flags_pointer)
        end

        it "has athaa type" do
          LAME.should have_flag(:athaa_type).with_value(-1).for(@flags_pointer)
          LAME.should be_able_to_set(:athaa_type).to(1).for(@flags_pointer)
        end

        it "has athaa sensitivity" do
          LAME.should have_flag(:athaa_sensitivity).with_value(0.0).for(@flags_pointer)
          LAME.should be_able_to_set(:athaa_sensitivity).to(1.0).for(@flags_pointer)
        end
      end

      context "blocks" do
        it "has allow diff short" do
          LAME.should have_flag(:allow_diff_short).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:allow_diff_short).to(1).for(@flags_pointer)
        end

        it "has useTemporal" do
          LAME.should have_flag(:useTemporal).with_value(1).for(@flags_pointer)
          LAME.should be_able_to_set(:useTemporal).to(0).for(@flags_pointer)
        end

        it "has interChRatio" do
          LAME.should have_flag(:interChRatio).with_value(0.0002).for(@flags_pointer)
          LAME.should be_able_to_set(:interChRatio).to(0.0003).for(@flags_pointer)
        end

        it "has no short blocks" do
          LAME.should have_flag(:no_short_blocks).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:no_short_blocks).to(1).for(@flags_pointer)
        end

        it "has force short blocks" do
          LAME.should have_flag(:force_short_blocks).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:force_short_blocks).to(1).for(@flags_pointer)
        end

        it "has emphasis" do
          LAME.should have_flag(:emphasis).with_value(0).for(@flags_pointer)
          LAME.should be_able_to_set(:emphasis).to(1).for(@flags_pointer)
        end
      end

      context "internal variables" do
        it "has a version" do
          LAME.should have_getter(:version).with_value(1).for(@flags_pointer)
        end

        it "has encoder delay" do
          LAME.should have_getter(:encoder_delay).with_value(576).for(@flags_pointer)
        end

        it "has encoder padding" do
          LAME.should have_getter(:encoder_padding).with_value(0).for(@flags_pointer)
        end

        it "has framesize" do
          LAME.should have_getter(:framesize).with_value(1152).for(@flags_pointer)
        end

        it "has mf samples to encode" do
          LAME.should have_getter(:mf_samples_to_encode).with_value(1728).for(@flags_pointer)
        end

        # mp3buffer (see below)

        it "has frameNum" do
          LAME.should have_getter(:frameNum).with_value(0).for(@flags_pointer)
        end

        # unpredictable default value between versions:
        it "has totalframes" do
          # LAME.should have_getter(:totalframes).with_value(3728272).for(@flags_pointer)
          LAME.should have_getter(:totalframes).for(@flags_pointer)
        end

        it "has RatioGain" do
          LAME.should have_getter(:RadioGain).with_value(0).for(@flags_pointer)
        end

        it "has AudiophileGain" do
          LAME.should have_getter(:AudiophileGain).with_value(0).for(@flags_pointer)
        end

        it "has PeakSample" do
          LAME.should have_getter(:PeakSample).with_value(0.0).for(@flags_pointer)
        end

        it "has noclipGainChange" do
          LAME.should have_getter(:noclipGainChange).with_value(0).for(@flags_pointer)
        end

        it "has noclipScale" do
          LAME.should have_getter(:noclipScale).with_value(-1.0).for(@flags_pointer)
        end
      end

      context "version" do
        it "has a version" do
          LAME.get_lame_version.should =~ /3\.\d\d\.\d/
        end

        it "has a short version" do
          LAME.get_lame_short_version.should =~ /3\.\d\d\.\d/
        end

        it "has a very short version" do
          LAME.get_lame_very_short_version.should =~ /LAME3\.\d\dr\d/
        end

        it "has a psy version" do
          LAME.get_psy_version.should eql "1.0"
        end

        it "has a url" do
          LAME.get_lame_url.should eql "http://lame.sf.net"
        end

        it "has os bitness" do
          LAME.get_lame_os_bitness.should =~ /(32|64)bits/
        end

        context "numerical version" do

          let(:version) { LAME.get_lame_version_numerical(@flags_pointer) }
          it "has a major version" do
            version[:major].should eql 3

          end
          it "has a minor version" do
            version[:minor].should eql 99
          end

          it "has a alpha version" do
            version[:alpha].should eql 0
          end

          it "has a beta version" do
            version[:beta].should eql 0
          end

          it "has a psy_major version" do
            version[:psy_major].should eql 1
          end

          it "has a psy_minor version" do
            version[:psy_minor].should eql 0
          end

          it "has a psy_alpha version" do
            version[:psy_alpha].should eql 0
          end

          it "has a psy_beta version" do
            version[:psy_beta].should eql 0
          end

          it "has features" do
            version[:features].should eql ""
          end
        end

      end
    end

    context "with custom logging" do

      it "has size mp3buffer" do
        # this call produces a 'stange error flushing buffer' warning, suppress it:
        callback = ::FFI::Function.new(:void, [:string, :pointer]) do |format, arguments|
          # do nothing
        end

        LAME.lame_set_errorf(@flags_pointer, callback)
        LAME.lame_init_params(@flags_pointer)

        LAME.should have_getter(:size_mp3buffer).with_value(834).for(@flags_pointer)
      end

      it "prints config" do
        pending "we need to be able to tweak logging to be able to test this"
        LAME.lame_print_config(@flags_pointer)
      end

      it "prints internals" do
        pending "we need to be able to tweak logging to be able to test this"
        LAME.lame_print_internals(@flags_pointer)
      end

    end

    context "tables" do

      it "has the bitrate table" do
        table = (0...3).map do |mpeg_version|
                  (0...16).map do |table_index|
                    LAME.lame_get_bitrate(mpeg_version, table_index)
                  end
                end
        expected = [
          [0, 8, 16, 24, 32, 40, 48, 56, 64, 80, 96, 112, 128, 144, 160, -1],
          [0, 32, 40, 48, 56, 64, 80, 96, 112, 128, 160, 192, 224, 256, 320, -1],
          [0, 8, 16, 24, 32, 40, 48, 56, 64, -1, -1, -1, -1, -1, -1, -1]
        ]

        table.should eql expected
      end

      it "has the samplerate table" do
        table = (0...3).map do |mpeg_version|
                  (0...4).map do |table_index|
                    LAME.lame_get_samplerate(mpeg_version, table_index)
                  end
                end

        expected = [
          [22050, 24000, 16000, -1],
          [44100, 48000, 32000, -1],
          [11025, 12000, 8000, -1]
        ]

        table.should eql expected
      end

    end

  end
end
