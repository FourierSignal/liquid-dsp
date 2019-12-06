# Sources info to CMake.

# This is intended to be called as include from the main CMakeLists.txt so paths
# are relative to that

# To fill in with the extra stuff
set(autotest_EXTRA_SOURCES)
set(benchmark_EXTRA_SOURCES)

# Set sources directories
set(agc_SOURCES # src/agc/src/agc.c
    src/agc/src/agc_crcf.c src/agc/src/agc_rrrf.c)
set(agc_BENCHMARKS_SOURCES src/agc/bench/agc_crcf_benchmark.c)
set(agc_AUTOTESTS_SOURCES src/agc/tests/agc_crcf_autotest.c)

set(audio_SOURCES src/audio/src/cvsd.c)
set(audio_BENCHMARKS_SOURCES src/audio/bench/cvsd_benchmark.c)
set(audio_AUTOTESTS_SOURCES src/audio/tests/cvsd_autotest.c)

set(buffer_SOURCES
    # src/buffer/src/buffer.c
    src/buffer/src/buffercf.c
    src/buffer/src/bufferf.c
    # src/buffer/src/cbuffer.c src/buffer/src/wdelay.c src/buffer/src/window.c
)
set(buffer_BENCHMARKS_SOURCES
    src/buffer/bench/cbuffer_benchmark.c
    src/buffer/bench/window_push_benchmark.c
    src/buffer/bench/window_read_benchmark.c)
set(buffer_AUTOTESTS_SOURCES
    src/buffer/tests/cbuffer_autotest.c
    # src/buffer/tests/sbuffer_autotest.c
    src/buffer/tests/wdelay_autotest.c src/buffer/tests/window_autotest.c)

set(channel_SOURCES src/channel/src/channel.c src/channel/src/channel_cccf.c
                    src/channel/src/tvmpch.c)
set(channel_BENCHMARKS_SOURCES)
set(channel_AUTOTESTS_SOURCES)

set(dotprod_C_SOURCES # src/dotprod/src/dotprod.c
    src/dotprod/src/dotprod_cccf.c src/dotprod/src/dotprod_crcf.c
    src/dotprod/src/dotprod_rrrf.c src/dotprod/src/sumsq.c)
set(dotprod_ALTIVEC_SOURCES
    src/dotprod/src/dotprod_cccf.c src/dotprod/src/dotprod_crcf.av.c
    src/dotprod/src/dotprod_rrrf.av.c src/dotprod/src/sumsq.c)
set(dotprod_SSE_SOURCES
    src/dotprod/src/dotprod_cccf.mmx.c
    src/dotprod/src/dotprod_crcf.mmx.c
    src/dotprod/src/dotprod_rrrf.mmx.c
    src/dotprod/src/sumsq.mmx.c
    # src/dotprod/src/dotprod_rrrf.sse4.c
)
set(dotprod_NEON_SOURCES
    src/dotprod/src/dotprod_cccf.neon.c src/dotprod/src/dotprod_crcf.neon.c
    src/dotprod/src/dotprod_rrrf.neon.c src/dotprod/src/sumsq.c)
set(dotprod_BENCHMARKS_SOURCES
    src/dotprod/bench/dotprod_cccf_benchmark.c
    src/dotprod/bench/dotprod_crcf_benchmark.c
    src/dotprod/bench/dotprod_rrrf_benchmark.c
    src/dotprod/bench/sumsqcf_benchmark.c
    src/dotprod/bench/sumsqf_benchmark.c)
set(dotprod_AUTOTESTS_SOURCES
    src/dotprod/tests/dotprod_cccf_autotest.c
    src/dotprod/tests/dotprod_crcf_autotest.c
    src/dotprod/tests/dotprod_rrrf_autotest.c
    src/dotprod/tests/sumsqcf_autotest.c
    src/dotprod/tests/sumsqf_autotest.c)
# Adjust the sources for the system
if(LIQUID_SIMDOVERRIDE)
  set(dotprod_SOURCES ${dotprod_C_SOURCES})
elseif(HAVE_SSE41 AND HAVE_SMMINTRIN_H)
  set(dotprod_SOURCES ${dotprod_SSE_SOURCES})
elseif(HAVE_SSE3 AND HAVE_PMMINTRIN_H)
  set(dotprod_SOURCES ${dotprod_SSE_SOURCES})
elseif(HAVE_SSE2 AND HAVE_EMMINTRIN_H)
  unset(HAVE_PMMINTRIN_H CACHE) # Unset otherwise SSE3 code kicks in.
  set(dotprod_SOURCES ${dotprod_SSE_SOURCES})
elseif(HAVE_ALTIVEC)
  set(dotprod_SOURCES ${dotprod_ALTIVEC_SOURCES})
elseif(HAVE_NEON OR HAVE_NEON64)
  set(dotprod_SOURCES ${dotprod_NEON_SOURCES})
else()
  set(dotprod_SOURCES ${dotprod_C_SOURCES})
endif()

set(equalization_SOURCES # src/equalization/src/eqlms.c
                         # src/equalization/src/eqrls.c
    src/equalization/src/equalizer_cccf.c src/equalization/src/equalizer_rrrf.c)
set(equalization_BENCHMARKS_SOURCES
    src/equalization/bench/eqlms_cccf_benchmark.c
    src/equalization/bench/eqrls_cccf_benchmark.c)
set(equalization_AUTOTESTS_SOURCES src/equalization/tests/eqlms_cccf_autotest.c
                                   src/equalization/tests/eqrls_rrrf_autotest.c)

set(fec_SOURCES
    # src/fec/src/c_ones_mod2.c
    # src/fec/src/c_ones_mod2_gentab.c
    src/fec/src/crc.c
    src/fec/src/fec.c
    src/fec/src/fec_conv.c
    src/fec/src/fec_conv_pmatrix.c
    src/fec/src/fec_conv_poly.c
    src/fec/src/fec_conv_punctured.c
    src/fec/src/fec_golay2412.c
    src/fec/src/fec_hamming128.c
    src/fec/src/fec_hamming128_gentab.c
    src/fec/src/fec_hamming1511.c
    src/fec/src/fec_hamming3126.c
    src/fec/src/fec_hamming74.c
    src/fec/src/fec_hamming84.c
    src/fec/src/fec_pass.c
    src/fec/src/fec_rep3.c
    src/fec/src/fec_rep5.c
    src/fec/src/fec_rs.c
    src/fec/src/fec_secded2216.c
    src/fec/src/fec_secded3932.c
    src/fec/src/fec_secded7264.c
    src/fec/src/interleaver.c
    src/fec/src/packetizer.c
    src/fec/src/sumproduct.c)
set(fec_BENCHMARKS_SOURCES
    src/fec/bench/crc_benchmark.c
    src/fec/bench/fec_decode_benchmark.c
    src/fec/bench/fec_encode_benchmark.c
    src/fec/bench/fecsoft_decode_benchmark.c
    src/fec/bench/interleaver_benchmark.c
    src/fec/bench/packetizer_decode_benchmark.c
    src/fec/bench/sumproduct_benchmark.c)
set(fec_AUTOTESTS_SOURCES
    src/fec/tests/crc_autotest.c
    src/fec/tests/fec_autotest.c
    src/fec/tests/fec_golay2412_autotest.c
    src/fec/tests/fec_hamming128_autotest.c
    src/fec/tests/fec_hamming1511_autotest.c
    src/fec/tests/fec_hamming3126_autotest.c
    src/fec/tests/fec_hamming74_autotest.c
    src/fec/tests/fec_hamming84_autotest.c
    src/fec/tests/fec_reedsolomon_autotest.c
    src/fec/tests/fec_rep3_autotest.c
    src/fec/tests/fec_rep5_autotest.c
    src/fec/tests/fec_secded2216_autotest.c
    src/fec/tests/fec_secded3932_autotest.c
    src/fec/tests/fec_secded7264_autotest.c
    src/fec/tests/fec_soft_autotest.c
    src/fec/tests/interleaver_autotest.c
    src/fec/tests/packetizer_autotest.c)

set(fft_SOURCES
    # src/fft/src/asgram.c
    # src/fft/src/dct_execute.c
    # src/fft/src/fct_execute.c
    # src/fft/src/fft_common.c
    # src/fft/src/fft_dft.c
    # src/fft/src/fft_mixed_radix.c
    # src/fft/src/fft_r2r_1d.c
    # src/fft/src/fft_rader.c
    # src/fft/src/fft_rader2.c
    # src/fft/src/fft_radix2.c
    src/fft/src/fft_utilities.c
    src/fft/src/fftf.c
    # src/fft/src/spgram.c
    src/fft/src/spgramcf.c
    src/fft/src/spgramf.c
    # src/fft/src/spwaterfall.c
)
set(fft_BENCHMARKS_SOURCES
    src/fft/bench/fft_composite_benchmark.c src/fft/bench/fft_prime_benchmark.c
    src/fft/bench/fft_r2r_benchmark.c src/fft/bench/fft_radix2_benchmark.c)
set(fft_BENCHMARKSEXTRA_SOURCES src/fft/bench/fft_runbench.c)
# Update benchmark_EXTRA_SOURCES
set(benchmark_EXTRA_SOURCES ${benchmark_EXTRA_SOURCES}
                            ${fft_BENCHMARKSEXTRA_SOURCES})
set(fft_AUTOTESTS_SOURCES
    src/fft/tests/fft_composite_autotest.c
    src/fft/tests/fft_prime_autotest.c
    src/fft/tests/fft_r2r_autotest.c
    src/fft/tests/fft_radix2_autotest.c
    # src/fft/tests/fft_runtest.c src/fft/tests/fft_runtest.h
    src/fft/tests/fft_shift_autotest.c
    src/fft/tests/fft_small_autotest.c
    # src/fft/tests/gen_fft_data.m src/fft/tests/gen_fft_files.m
)
set(fft_TESTDATA_SOURCES
    src/fft/tests/data/fft_data_10.c
    src/fft/tests/data/fft_data_120.c
    src/fft/tests/data/fft_data_130.c
    src/fft/tests/data/fft_data_157.c
    src/fft/tests/data/fft_data_16.c
    src/fft/tests/data/fft_data_17.c
    src/fft/tests/data/fft_data_192.c
    src/fft/tests/data/fft_data_2.c
    src/fft/tests/data/fft_data_20.c
    src/fft/tests/data/fft_data_21.c
    src/fft/tests/data/fft_data_22.c
    src/fft/tests/data/fft_data_24.c
    src/fft/tests/data/fft_data_26.c
    src/fft/tests/data/fft_data_3.c
    src/fft/tests/data/fft_data_30.c
    src/fft/tests/data/fft_data_317.c
    src/fft/tests/data/fft_data_32.c
    src/fft/tests/data/fft_data_35.c
    src/fft/tests/data/fft_data_36.c
    src/fft/tests/data/fft_data_4.c
    src/fft/tests/data/fft_data_43.c
    src/fft/tests/data/fft_data_48.c
    src/fft/tests/data/fft_data_5.c
    src/fft/tests/data/fft_data_509.c
    src/fft/tests/data/fft_data_6.c
    src/fft/tests/data/fft_data_63.c
    src/fft/tests/data/fft_data_64.c
    src/fft/tests/data/fft_data_7.c
    src/fft/tests/data/fft_data_79.c
    src/fft/tests/data/fft_data_8.c
    src/fft/tests/data/fft_data_9.c
    src/fft/tests/data/fft_data_92.c
    src/fft/tests/data/fft_data_96.c
    src/fft/tests/data/fft_r2rdata_27.c
    src/fft/tests/data/fft_r2rdata_32.c
    src/fft/tests/data/fft_r2rdata_8.c)
# Update autotest_EXTRA_SOURCES
set(autotest_EXTRA_SOURCES ${autotest_EXTRA_SOURCES} ${fft_TESTDATA_SOURCES})

set(filter_SOURCES
    # src/filter/src/autocorr.c
    src/filter/src/bessel.c
    # src/filter/src/bilinear.c
    src/filter/src/butter.c
    src/filter/src/cheby1.c
    src/filter/src/cheby2.c
    src/filter/src/ellip.c
    # src/filter/src/fftfilt.c
    src/filter/src/filter_cccf.c
    src/filter/src/filter_crcf.c
    src/filter/src/filter_rrrf.c
    # src/filter/src/firdecim.c
    src/filter/src/firdes.c
    src/filter/src/firdespm.c
    # src/filter/src/firfarrow.c src/filter/src/firfilt.c
    # src/filter/src/firhilb.c src/filter/src/firinterp.c
    # src/filter/src/firpfb.c
    src/filter/src/fnyquist.c
    src/filter/src/gmsk.c
    src/filter/src/group_delay.c
    src/filter/src/hM3.c
    # src/filter/src/iirdecim.c
    src/filter/src/iirdes.c
    src/filter/src/iirdes.pll.c
    # src/filter/src/iirfilt.c src/filter/src/iirfiltsos.c
    # src/filter/src/iirhilb.c src/filter/src/iirinterp.c
    src/filter/src/lpc.c
    # src/filter/src/msresamp.c src/filter/src/msresamp2.c
    # src/filter/src/ordfilt.c
    src/filter/src/rcos.c
    # src/filter/src/resamp.c src/filter/src/resamp.fixed.c
    # src/filter/src/resamp2.c
    src/filter/src/rkaiser.c
    src/filter/src/rrcos.c
    # src/filter/src/rresamp.c src/filter/src/symsync.c
)
set(filter_BENCHMARKS_SOURCES
    src/filter/bench/fftfilt_crcf_benchmark.c
    src/filter/bench/firdecim_crcf_benchmark.c
    src/filter/bench/firfilt_crcf_benchmark.c
    src/filter/bench/firhilb_benchmark.c
    src/filter/bench/firinterp_crcf_benchmark.c
    src/filter/bench/iirdecim_crcf_benchmark.c
    src/filter/bench/iirfilt_crcf_benchmark.c
    src/filter/bench/iirinterp_crcf_benchmark.c
    src/filter/bench/resamp_crcf_benchmark.c
    src/filter/bench/resamp2_crcf_benchmark.c
    # src/filter/bench/rresamp_crcf_benchmark.c
    src/filter/bench/symsync_crcf_benchmark.c)
set(filter_AUTOTESTS_SOURCES
    # src/filter/tests/fftfilt_autotest.h
    # src/filter/tests/fftfilt_runtest.c
    src/filter/tests/fftfilt_xxxf_autotest.c
    src/filter/tests/filter_crosscorr_autotest.c
    # src/filter/tests/firdecim_autotest.h src/filter/tests/firdecim_runtest.c
    src/filter/tests/firdecim_xxxf_autotest.c
    src/filter/tests/firdes_autotest.c
    src/filter/tests/firdespm_autotest.c
    # src/filter/tests/firfilt_autotest.h
    # src/filter/tests/firfilt_cccf_notch_autotest.c
    # src/filter/tests/firfilt_runtest.c
    src/filter/tests/firfilt_xxxf_autotest.c
    src/filter/tests/firhilb_autotest.c
    src/filter/tests/firinterp_autotest.c
    src/filter/tests/firpfb_autotest.c
    src/filter/tests/groupdelay_autotest.c
    src/filter/tests/iirdes_autotest.c
    # src/filter/tests/iirfilt_autotest.h src/filter/tests/iirfilt_runtest.c
    src/filter/tests/iirfilt_xxxf_autotest.c
    src/filter/tests/iirfiltsos_rrrf_autotest.c
    # src/filter/tests/lpc_autotest.c
    src/filter/tests/msresamp_crcf_autotest.c
    src/filter/tests/resamp_crcf_autotest.c
    src/filter/tests/resamp2_crcf_autotest.c
    # src/filter/tests/rresamp_crcf_autotest.c
    src/filter/tests/symsync_crcf_autotest.c
    src/filter/tests/symsync_rrrf_autotest.c)
set(filter_TESTDATA_SOURCES
    src/filter/tests/data/fftfilt_cccf_data_h13x256.c
    src/filter/tests/data/fftfilt_cccf_data_h23x256.c
    src/filter/tests/data/fftfilt_cccf_data_h4x256.c
    src/filter/tests/data/fftfilt_cccf_data_h7x256.c
    src/filter/tests/data/fftfilt_crcf_data_h13x256.c
    src/filter/tests/data/fftfilt_crcf_data_h23x256.c
    src/filter/tests/data/fftfilt_crcf_data_h4x256.c
    src/filter/tests/data/fftfilt_crcf_data_h7x256.c
    src/filter/tests/data/fftfilt_rrrf_data_h13x256.c
    src/filter/tests/data/fftfilt_rrrf_data_h23x256.c
    src/filter/tests/data/fftfilt_rrrf_data_h4x256.c
    src/filter/tests/data/fftfilt_rrrf_data_h7x256.c
    src/filter/tests/data/firdecim_cccf_data_M2h4x20.c
    src/filter/tests/data/firdecim_cccf_data_M3h7x30.c
    src/filter/tests/data/firdecim_cccf_data_M4h13x40.c
    src/filter/tests/data/firdecim_cccf_data_M5h23x50.c
    src/filter/tests/data/firdecim_crcf_data_M2h4x20.c
    src/filter/tests/data/firdecim_crcf_data_M3h7x30.c
    src/filter/tests/data/firdecim_crcf_data_M4h13x40.c
    src/filter/tests/data/firdecim_crcf_data_M5h23x50.c
    src/filter/tests/data/firdecim_rrrf_data_M2h4x20.c
    src/filter/tests/data/firdecim_rrrf_data_M3h7x30.c
    src/filter/tests/data/firdecim_rrrf_data_M4h13x40.c
    src/filter/tests/data/firdecim_rrrf_data_M5h23x50.c
    src/filter/tests/data/firfilt_cccf_data_h13x32.c
    src/filter/tests/data/firfilt_cccf_data_h23x64.c
    src/filter/tests/data/firfilt_cccf_data_h4x8.c
    src/filter/tests/data/firfilt_cccf_data_h7x16.c
    src/filter/tests/data/firfilt_crcf_data_h13x32.c
    src/filter/tests/data/firfilt_crcf_data_h23x64.c
    src/filter/tests/data/firfilt_crcf_data_h4x8.c
    src/filter/tests/data/firfilt_crcf_data_h7x16.c
    src/filter/tests/data/firfilt_rrrf_data_h13x32.c
    src/filter/tests/data/firfilt_rrrf_data_h23x64.c
    src/filter/tests/data/firfilt_rrrf_data_h4x8.c
    src/filter/tests/data/firfilt_rrrf_data_h7x16.c
    src/filter/tests/data/gen_firfilt_data.m
    src/filter/tests/data/gen_iirfilt_data.m
    src/filter/tests/data/iirfilt_cccf_data_h3x64.c
    src/filter/tests/data/iirfilt_cccf_data_h5x64.c
    src/filter/tests/data/iirfilt_cccf_data_h7x64.c
    src/filter/tests/data/iirfilt_crcf_data_h3x64.c
    src/filter/tests/data/iirfilt_crcf_data_h5x64.c
    src/filter/tests/data/iirfilt_crcf_data_h7x64.c
    src/filter/tests/data/iirfilt_rrrf_data_h3x64.c
    src/filter/tests/data/iirfilt_rrrf_data_h5x64.c
    src/filter/tests/data/iirfilt_rrrf_data_h7x64.c)
# Update autotest_EXTRA_SOURCES
set(autotest_EXTRA_SOURCES
    ${autotest_EXTRA_SOURCES} ${filter_TESTDATA_SOURCES}
    src/filter/tests/fftfilt_runtest.c src/filter/tests/firdecim_runtest.c
    src/filter/tests/firfilt_runtest.c src/filter/tests/iirfilt_runtest.c)

set(framing_SOURCES
    src/framing/src/bpacketgen.c
    src/framing/src/bpacketsync.c
    # src/framing/src/bpresync.c
    src/framing/src/bpresync_cccf.c
    # src/framing/src/bsync.c
    src/framing/src/bsync_cccf.c
    src/framing/src/bsync_crcf.c
    src/framing/src/bsync_rrrf.c
    src/framing/src/detector_cccf.c
    # src/framing/src/dsssframegen.c src/framing/src/dsssframesync.c
    src/framing/src/flexframegen.c
    src/framing/src/flexframesync.c
    src/framing/src/framedatastats.c
    src/framing/src/framegen64.c
    src/framing/src/framesync64.c
    src/framing/src/framesyncstats.c
    # src/framing/src/fskframegen.c src/framing/src/fskframesync.c
    src/framing/src/gmskframegen.c
    src/framing/src/gmskframesync.c
    # src/framing/src/msource.c
    src/framing/src/msourcecf.c
    src/framing/src/ofdmflexframegen.c
    src/framing/src/ofdmflexframesync.c
    # src/framing/src/presync.c
    src/framing/src/presync_cccf.c
    src/framing/src/qdetector_cccf.c
    src/framing/src/qpacketmodem.c
    src/framing/src/qpilotgen.c
    src/framing/src/qpilotsync.c
    # src/framing/src/qsource.c src/framing/src/symstream.c
    src/framing/src/symstreamcf.c
    # src/framing/src/symtrack.c
    src/framing/src/symtrack_cccf.c)
set(framing_BENCHMARKS_SOURCES
    src/framing/bench/bpacketsync_benchmark.c
    src/framing/bench/bpresync_benchmark.c
    src/framing/bench/bsync_benchmark.c
    src/framing/bench/detector_benchmark.c
    src/framing/bench/flexframesync_benchmark.c
    src/framing/bench/framesync64_benchmark.c
    src/framing/bench/gmskframesync_benchmark.c
    src/framing/bench/presync_benchmark.c
    # src/framing/bench/qdetector_benchmark.c
)
set(framing_AUTOTESTS_SOURCES
    src/framing/tests/bpacketsync_autotest.c
    src/framing/tests/bsync_autotest.c
    src/framing/tests/detector_autotest.c
    src/framing/tests/flexframesync_autotest.c
    src/framing/tests/framesync64_autotest.c
    src/framing/tests/qdetector_cccf_autotest.c
    src/framing/tests/qpacketmodem_autotest.c
    src/framing/tests/qpilotsync_autotest.c)

set(math_SOURCES
    src/math/src/math.bessel.c
    src/math/src/math.c
    src/math/src/math.complex.c
    src/math/src/math.gamma.c
    src/math/src/math.trig.c
    src/math/src/modular_arithmetic.c
    src/math/src/poly.c
    # src/math/src/poly.common.c src/math/src/poly.expand.c
    # src/math/src/poly.findroots.c src/math/src/poly.lagrange.c
    src/math/src/polyc.c
    src/math/src/polycf.c
    src/math/src/polyf.c
    src/math/src/windows.c)
set(math_BENCHMARKS_SOURCES src/math/bench/polyfit_benchmark.c)
set(math_AUTOTESTS_SOURCES
    # src/math/tests/gcd_autotest.c
    src/math/tests/kbd_autotest.c
    src/math/tests/math_autotest.c
    src/math/tests/math_bessel_autotest.c
    src/math/tests/math_complex_autotest.c
    src/math/tests/math_gamma_autotest.c
    src/math/tests/polynomial_autotest.c
    # src/math/tests/polynomial_findroots_autotest.c
    # src/math/tests/prime_autotest.c
)

set(matrix_SOURCES
    # src/matrix/src/matrix.base.c
    src/matrix/src/matrix.c
    # src/matrix/src/matrix.cgsolve.c src/matrix/src/matrix.chol.c
    # src/matrix/src/matrix.gramschmidt.c src/matrix/src/matrix.inv.c
    # src/matrix/src/matrix.linsolve.c src/matrix/src/matrix.ludecomp.c
    # src/matrix/src/matrix.math.c src/matrix/src/matrix.qrdecomp.c
    src/matrix/src/matrixc.c
    src/matrix/src/matrixcf.c
    src/matrix/src/matrixf.c
    # src/matrix/src/smatrix.c
    src/matrix/src/smatrix.common.c
    src/matrix/src/smatrixb.c
    src/matrix/src/smatrixf.c
    src/matrix/src/smatrixi.c)
set(matrix_BENCHMARKS_SOURCES
    src/matrix/bench/matrixf_inv_benchmark.c
    src/matrix/bench/matrixf_linsolve_benchmark.c
    src/matrix/bench/matrixf_mul_benchmark.c
    src/matrix/bench/smatrixf_mul_benchmark.c)
set(matrix_AUTOTESTS_SOURCES
    # src/matrix/tests/gendata_write_autotests.m
    # src/matrix/tests/gendata_write_header.m
    # src/matrix/tests/gendata_write_matrix.m
    # src/matrix/tests/matrix_data.h
    src/matrix/tests/matrixcf_autotest.c src/matrix/tests/matrixf_autotest.c
    src/matrix/tests/smatrixb_autotest.c src/matrix/tests/smatrixf_autotest.c
    src/matrix/tests/smatrixi_autotest.c)
set(matrix_TESTDATA_SOURCES
    src/matrix/tests/data/matrixcf_data_add.c
    src/matrix/tests/data/matrixcf_data_aug.c
    src/matrix/tests/data/matrixcf_data_chol.c
    src/matrix/tests/data/matrixcf_data_inv.c
    src/matrix/tests/data/matrixcf_data_linsolve.c
    src/matrix/tests/data/matrixcf_data_ludecomp.c
    src/matrix/tests/data/matrixcf_data_mul.c
    src/matrix/tests/data/matrixcf_data_qrdecomp.c
    src/matrix/tests/data/matrixcf_data_transmul.c
    src/matrix/tests/data/matrixf_data_add.c
    src/matrix/tests/data/matrixf_data_aug.c
    src/matrix/tests/data/matrixf_data_cgsolve.c
    src/matrix/tests/data/matrixf_data_chol.c
    src/matrix/tests/data/matrixf_data_gramschmidt.c
    src/matrix/tests/data/matrixf_data_inv.c
    src/matrix/tests/data/matrixf_data_linsolve.c
    src/matrix/tests/data/matrixf_data_ludecomp.c
    src/matrix/tests/data/matrixf_data_mul.c
    src/matrix/tests/data/matrixf_data_qrdecomp.c
    src/matrix/tests/data/matrixf_data_transmul.c)
# Update autotest_EXTRA_SOURCES
set(autotest_EXTRA_SOURCES ${autotest_EXTRA_SOURCES} ${matrix_TESTDATA_SOURCES})

set(modem_SOURCES
    src/modem/src/ampmodem.c
    src/modem/src/cpfskdem.c
    src/modem/src/cpfskmod.c
    # src/modem/src/freqdem.c src/modem/src/freqmod.c
    src/modem/src/fskdem.c
    src/modem/src/fskmod.c
    src/modem/src/gmskdem.c
    src/modem/src/gmskmod.c
    # src/modem/src/modem_apsk.c
    src/modem/src/modem_apsk_const.c
    # src/modem/src/modem_arb.c
    src/modem/src/modem_arb_const.c
    # src/modem/src/modem_ask.c src/modem/src/modem_bpsk.c
    # src/modem/src/modem_common.c src/modem/src/modem_dpsk.c
    # src/modem/src/modem_ook.c src/modem/src/modem_psk.c
    # src/modem/src/modem_qam.c src/modem/src/modem_qpsk.c
    # src/modem/src/modem_sqam128.c src/modem/src/modem_sqam32.c
    src/modem/src/modem_utilities.c
    src/modem/src/modemf.c)
set(modem_BENCHMARKS_SOURCES
    src/modem/bench/freqdem_benchmark.c
    src/modem/bench/freqmod_benchmark.c
    src/modem/bench/fskdem_benchmark.c
    src/modem/bench/fskmod_benchmark.c
    src/modem/bench/gmskmodem_benchmark.c
    src/modem/bench/modem_demodsoft_benchmark.c
    src/modem/bench/modem_demodulate_benchmark.c
    src/modem/bench/modem_modulate_benchmark.c)
set(modem_AUTOTESTS_SOURCES
    # src/modem/tests/ampmodem_autotest.c
    src/modem/tests/cpfskmodem_autotest.c
    src/modem/tests/freqmodem_autotest.c
    src/modem/tests/fskmodem_autotest.c
    src/modem/tests/modem_autotest.c
    src/modem/tests/modem_demodsoft_autotest.c
    src/modem/tests/modem_demodstats_autotest.c)

set(multichannel_SOURCES
    # src/multichannel/src/firpfbch.c
    src/multichannel/src/firpfbch_cccf.c
    src/multichannel/src/firpfbch_crcf.c
    # src/multichannel/src/firpfbch_old.c src/multichannel/src/firpfbch2.c
    # src/multichannel/src/firpfbchr.c
    src/multichannel/src/ofdmframe.common.c
    src/multichannel/src/ofdmframegen.c
    src/multichannel/src/ofdmframesync.c)
set(multichannel_BENCHMARKS_SOURCES
    src/multichannel/bench/firpfbch_crcf_benchmark.c
    src/multichannel/bench/firpfbch2_crcf_benchmark.c
    # src/multichannel/bench/firpfbchr_crcf_benchmark.c
    src/multichannel/bench/ofdmframesync_acquire_benchmark.c
    src/multichannel/bench/ofdmframesync_rxsymbol_benchmark.c)
set(multichannel_AUTOTESTS_SOURCES
    src/multichannel/tests/firpfbch_crcf_analyzer_autotest.c
    src/multichannel/tests/firpfbch_crcf_synthesizer_autotest.c
    src/multichannel/tests/firpfbch2_crcf_autotest.c
    src/multichannel/tests/ofdmframesync_autotest.c)

set(nco_SOURCES
    # src/nco/src/nco.c
    src/nco/src/nco.utilities.c src/nco/src/nco_crcf.c

    # src/nco/src/synth.c src/nco/src/synth_crcf.c
)
set(nco_BENCHMARKS_SOURCES src/nco/bench/nco_benchmark.c
                           src/nco/bench/vco_benchmark.c)
set(nco_AUTOTESTS_SOURCES
    # src/nco/tests/gen_nco_data.m
    src/nco/tests/nco_crcf_frequency_autotest.c
    # src/nco/tests/nco_crcf_mix_autotest.c
    src/nco/tests/nco_crcf_phase_autotest.c
    src/nco/tests/nco_crcf_pll_autotest.c
    src/nco/tests/unwrap_phase_autotest.c)
set(nco_TESTDATA_SOURCES
    src/nco/tests/data/nco_sincos_fsqrt1_2.c
    src/nco/tests/data/nco_sincos_fsqrt1_3.c
    src/nco/tests/data/nco_sincos_fsqrt1_5.c
    src/nco/tests/data/nco_sincos_fsqrt1_7.c)
# Update autotest_EXTRA_SOURCES
set(autotest_EXTRA_SOURCES ${autotest_EXTRA_SOURCES} ${nco_TESTDATA_SOURCES})

set(optim_SOURCES
    src/optim/src/chromosome.c
    src/optim/src/gasearch.c
    src/optim/src/gradsearch.c
    src/optim/src/optim.common.c
    # src/optim/src/optim.h
    src/optim/src/qnsearch.c
    src/optim/src/utilities.c)
set(optim_BENCHMARKS_SOURCES)
set(optim_AUTOTESTS_SOURCES src/optim/tests/gradsearch_autotest.c)

set(quantization_SOURCES
    src/quantization/src/compand.c
    # src/quantization/src/quantizer.c
    src/quantization/src/quantizer.inline.c
    src/quantization/src/quantizercf.c
    src/quantization/src/quantizerf.c)
set(quantization_BENCHMARKS_SOURCES
    src/quantization/bench/compander_benchmark.c
    src/quantization/bench/quantizer_benchmark.c)
set(quantization_AUTOTESTS_SOURCES src/quantization/tests/compand_autotest.c
                                   src/quantization/tests/quantize_autotest.c)

set(random_SOURCES
    src/random/src/rand.c
    src/random/src/randexp.c
    src/random/src/randgamma.c
    src/random/src/randn.c
    src/random/src/randnakm.c
    src/random/src/randricek.c
    src/random/src/randweib.c
    src/random/src/scramble.c)
set(random_BENCHMARKS_SOURCES src/random/bench/random_benchmark.c)
set(random_AUTOTESTS_SOURCES # src/random/tests/random_autotest.c
    src/random/tests/scramble_autotest.c)

set(sequence_SOURCES src/sequence/src/bsequence.c src/sequence/src/msequence.c)
set(sequence_BENCHMARKS_SOURCES src/sequence/bench/bsequence_benchmark.c)
set(sequence_AUTOTESTS_SOURCES
    src/sequence/tests/bsequence_autotest.c
    src/sequence/tests/complementary_codes_autotest.c
    src/sequence/tests/msequence_autotest.c)

set(utility_SOURCES
    src/utility/src/bshift_array.c
    src/utility/src/byte_utilities.c
    src/utility/src/msb_index.c
    # src/utility/src/msb_index.x86.s
    src/utility/src/pack_bytes.c
    src/utility/src/shift_array.c
    src/utility/src/utility.c)
set(utility_BENCHMARKS_SOURCES # src/utility/bench/byte_utilities_benchmark.c
)
set(utility_AUTOTESTS_SOURCES
    # src/utility/tests/bdotprod_gentest.m
    src/utility/tests/bshift_array_autotest.c
    src/utility/tests/count_bits_autotest.c
    src/utility/tests/pack_bytes_autotest.c
    src/utility/tests/shift_array_autotest.c)

set(vector_SOURCES
    # src/vector/src/vector_add.c
    # src/vector/src/vector_mul.c
    # src/vector/src/vector_norm.c
    # src/vector/src/vector_trig.c
    src/vector/src/vectorcf_add.port.c
    src/vector/src/vectorcf_mul.port.c
    src/vector/src/vectorcf_norm.port.c
    src/vector/src/vectorcf_trig.port.c
    src/vector/src/vectorf_add.port.c
    src/vector/src/vectorf_mul.port.c
    src/vector/src/vectorf_norm.port.c
    src/vector/src/vectorf_trig.port.c)
set(vector_BENCHMARKS_SOURCES)
set(vector_AUTOTESTS_SOURCES)
