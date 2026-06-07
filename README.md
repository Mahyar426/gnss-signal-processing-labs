<div align="center">

![header](https://readme-typing-svg.demolab.com?font=Fira+Code&size=26&pause=1000&color=00FF88&center=true&vCenter=true&width=800&lines=🛰️+GNSS+Signal+Processing+Labs;Raw+pseudoranges+to+multipath+mitigation.;Full+receiver+chain+built+in+MATLAB.)

```
 ██████╗ ███╗   ██╗███████╗███████╗
██╔════╝ ████╗  ██║██╔════╝██╔════╝
██║  ███╗██╔██╗ ██║███████╗███████╗
██║   ██║██║╚██╗██║╚════██║╚════██║
╚██████╔╝██║ ╚████║███████║███████║
 ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚══════╝
   acquisition · tracking · ranging · positioning
```

[![MATLAB](https://img.shields.io/badge/MATLAB-R2023b-orange?style=flat-square&logo=mathworks)](https://www.mathworks.com/)
[![GNSS](https://img.shields.io/badge/Systems-GPS_%7C_Galileo_%7C_GLONASS_%7C_BeiDou-blue?style=flat-square)](#)
[![Domain](https://img.shields.io/badge/Domain-Satellite_Navigation_%7C_Signal_Processing-00FF88?style=flat-square)](#)
[![Data](https://img.shields.io/badge/Data-Real_Android_GnssLogger_%2B_Binary_Captures-blueviolet?style=flat-square)](#)

</div>

---

Six end-to-end labs walking through the complete signal chain of a GNSS receiver — from Android raw measurements all the way to the correlation discriminators that lock onto a satellite signal. Each lab is a self-contained MATLAB implementation tackling a real engineering problem with real data.

| Lab | Topic | Key Techniques |
|-----|-------|----------------|
| **Lab 2** | Multi-Constellation Positioning | LMS & WLMS, ECEF→LLA without toolboxes, KML export |
| **Lab 3** | Spreading Code Generation | GPS C/A PRN via 10-stage LFSR, Gold codes, GPS ICD validation |
| **Lab 4** | Signal Modulation & Spectrum | IF signal generation, BOC modulation, Welch PSD |
| **Lab 5** | GNSS Acquisition | CAF over real binary captures, FFT-accelerated CCCF, Doppler search |
| **Lab 6** | Code Tracking & Multipath | DLL discriminators, E-L / nE-nL / dot-product, multipath error envelope |

---

## Lab Breakdown

### Lab 2 — Multi-Constellation Least Squares Positioning
Both standard **LMS** and **Weighted LMS** positioning engines built from scratch, fusing GPS, GLONASS, Galileo, and BeiDou simultaneously. Processes multi-epoch datasets with realistic UERE noise models, computes positioning error statistics, and exports KML tracks for Google Earth visualization.

- ECEF-to-LLA conversion implemented without toolboxes (`ecef2lla_noToolBox.m`)
- Multi-GNSS geometry matrix construction with constellation-specific weighting
- Exported results: `writeKML_GoogleEarth.m` → viewable satellite track overlays

---

### Lab 3 — GPS & Galileo Spreading Code Generation
GPS C/A PRN code generator using a 10-stage linear feedback shift register — all 32 PRN codes validated against the official GPS ICD specification. Extended to Galileo E1b/E1c. Deep-dive into code properties: autocorrelation peaks, cross-correlation floors, balance/run-length statistics.

```matlab
% Core PRN generator — Phase_Selector table maps PRN index to G2 tap pair
function Code = PRN_Generator(PRN_Code_Number)
  Phase_Selector = [2,6; 3,7; 4,8; ...];  % All 32 PRN tap assignments
  % 10-stage G1 + G2 LFSR — Gold code construction
```

---

### Lab 4 — Signal Generation & Spectral Analysis
Generates GPS and Galileo IF signals from scratch — complex carrier, spreading code upsampled at 16.368 MHz (`generateLocalCode.m`), and Binary Offset Carrier (BOC) modulation for Galileo (`generateLocalIIF.m`). Analyses resulting spectra using Welch's method and contrasts GPS BPSK vs. Galileo BOC(1,1) power spectral densities.

---

### Lab 5 — GNSS Signal Acquisition
Full **Cross-Ambiguity Function (CAF)** acquisition engine: 2D search over PRN code delay and Doppler frequency shift using FFT-accelerated cross-correlation. Doppler bins sweep ±5 kHz with spacing `Δf = 2/(3·Tcoh)` for guaranteed detection.

```matlab
% FFT-based CCCF per Doppler bin — run over all 32 GPS PRNs + all Galileo codes
CCCF_GPS(i,:) = ifft(fft(localSignal) .* conj(fft(RawData)));
CCCF_GPS(i,:) = CCCF_GPS(i,:) / DelayBins;
```

Runs on three **real binary GNSS captures** (`SignalRX_1/2/3.bin`) — not just simulations. Peak detection in delay-Doppler space identifies visible satellites and extracts coarse Doppler estimates.

---

### Lab 6 — Code Tracking & Multipath Mitigation
Implements the **Delay Lock Loop (DLL)** discriminator core with Early, Prompt, and Late correlators. Three discriminators compared:

| Discriminator | Formula | Property |
|---|---|---|
| Early-minus-Late (E-L) | `R_E − R_L` | Classic — simple, noise-sensitive |
| Normalized E-L (nE-L) | `(R_E − R_L) / (R_E + R_L) × 0.5` | Amplitude-normalized |
| Dot-Product | `(R_E² − R_L²) / (R_E² + R_L²) × 0.5` | Steeper slope, better sensitivity |

Synthetic multipath scenario: 0.4× amplitude reflected ray at 0.25 chip delay, added via `FlagMultipath` flag. Multipath error envelopes characterised for each discriminator — showing quantitatively which ones degrade least under reflections.

---

## Tech Stack

```
Language       : MATLAB
GNSS Data      : Android GnssLogger exports, real binary IF captures
Constellations : GPS (L1 C/A), Galileo (E1b/E1c), GLONASS, BeiDou
Signal Freq    : 1575.42 MHz (L1), IF at 4.092 MHz, fs = 16.368 MHz
Chip Rate      : 1.023 Mchip/s (GPS C/A)
```

---

## Skills Demonstrated

- Full GNSS receiver chain: spreading codes → IF signals → CAF acquisition → DLL tracking
- Statistical estimation: LMS, WLMS, multi-epoch fusion without toolbox shortcuts
- DSP fundamentals: FFT-based correlation, Welch PSD, complex baseband, digital filtering
- Multi-constellation processing: heterogeneous satellite fusion with noise weighting
- Real-world signal handling: Android GnssLogger pipeline, binary IF capture processing

---

*M.Sc. Communications Engineering — Politecnico di Torino*
