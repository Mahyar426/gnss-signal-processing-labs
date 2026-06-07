# 🛰️ Satellite Navigation Systems — Lab Portfolio

> From raw pseudoranges to multipath mitigation: a full-stack GNSS signal processing pipeline built in MATLAB, covering every layer of a modern satellite positioning system.

![MATLAB](https://img.shields.io/badge/MATLAB-R2023b-orange?style=flat-square&logo=mathworks)
![GNSS](https://img.shields.io/badge/Systems-GPS%20%7C%20Galileo%20%7C%20GLONASS%20%7C%20BeiDou-blue?style=flat-square)
![Domain](https://img.shields.io/badge/Domain-Signal%20Processing%20%7C%20Positioning-blueviolet?style=flat-square)
![Course](https://img.shields.io/badge/Course-Satellite%20Navigation%20Systems-green?style=flat-square)

---

## What's Inside

Six end-to-end labs that walk through the complete signal chain of a GNSS receiver — from Android raw measurements all the way down to the correlation discriminators that lock onto a satellite signal. Each lab is a self-contained MATLAB implementation tackling a real engineering problem.

| Lab | Topic | Key Techniques |
|-----|-------|----------------|
| **Lab 1** | Raw GNSS Processing | Android GnssLogger, pseudorange extraction, WLS PVT |
| **Lab 2** | Multi-Constellation Positioning | LMS & WLMS positioning, ECEF→LLA, multi-epoch fusion |
| **Lab 3** | Spreading Code Generation | GPS C/A PRN sequences, Gold codes, autocorrelation/cross-correlation |
| **Lab 4** | Signal Modulation & Spectrum | IF carrier generation, BOC modulation, Welch PSD, GPS vs Galileo |
| **Lab 5** | GNSS Acquisition | Cross-Ambiguity Function (CAF), Doppler search, real signal acquisition |
| **Lab 6** | Code Tracking & Multipath | DLL discriminators (E-L, nE-nL, dot-product), multipath analysis |

---

## Lab Breakdown

### Lab 1 — Real GNSS Data Processing
Starting from scratch with raw measurements exported from an Android device via the GnssLogger app. The pipeline reads raw pseudoranges, applies satellite clock corrections, retrieves live ephemeris from NASA's CDDIS service, and computes a full Weighted Least Squares PVT solution — turning a phone log file into a position fix on a map.

**Highlights:** ECEF coordinate transforms, C/No analysis, ephemeris-based satellite position computation.

---

### Lab 2 — Multi-Constellation Least Squares Positioning
Implements both standard **LMS** and **Weighted LMS** positioning engines from scratch, fusing observations from GPS, GLONASS, Galileo, and BeiDou simultaneously. Processes multi-epoch datasets with realistic UERE noise models, computes positioning error statistics, and exports KML tracks for Google Earth visualization.

**Highlights:** Multi-GNSS geometry matrices, UERE weighting, ECEF-to-LLA conversion without toolboxes.

---

### Lab 3 — GPS & Galileo Spreading Code Generation
Hand-builds the GPS C/A PRN code generator using linear feedback shift registers (LFSR), validates all 32 PRN codes against the official GPS ICD specification, and extends to Galileo E1b/E1c. Deep-dives into spreading code properties: autocorrelation peaks, cross-correlation floors, and balance/run-length statistics.

**Highlights:** Gold code theory, LFSR implementation, octal code validation against GPS ICD.

---

### Lab 4 — Signal Generation & Spectral Analysis
Generates GPS and Galileo IF signals from scratch — complex carrier, spreading code upsampling at 16.368 MHz, and Binary Offset Carrier (BOC) modulation for Galileo. Analyses the resulting spectra using Welch's method and visually contrasts GPS BPSK vs Galileo BOC(1,1) power spectral densities.

**Highlights:** BOC modulation, Welch PSD, complex baseband signal construction, IF signal architecture.

---

### Lab 5 — GNSS Signal Acquisition
Implements the full **Cross-Ambiguity Function (CAF)** acquisition engine: a 2D search over PRN code delay and Doppler frequency shift using FFT-accelerated cross-correlation. Runs over all 32 GPS PRNs and all Galileo codes to identify visible satellites, extract coarse Doppler estimates, and validate against real binary GNSS signal captures.

**Highlights:** FFT-based CCCF, Doppler bin search (±5 kHz), acquisition of real captured signals, CAF surface plotting.

---

### Lab 6 — Code Tracking & Multipath Mitigation
Implements the **Delay Lock Loop (DLL)** discriminator core: Early, Prompt, and Late correlators with Early-minus-Late, Normalized Early-minus-Late, and Dot-Product discriminator functions. Introduces a synthetic multipath scenario (0.4× amplitude reflected ray at 0.25 chip delay) and characterises each discriminator's sensitivity and multipath error envelope.

**Highlights:** DLL architecture, three discriminator comparisons, multipath error analysis, Butterworth chip shaping filter.

---

## Tech Stack

```
Language  : MATLAB
GNSS Data : Android GnssLogger, binary IF captures, synthetic simulations
Constellations: GPS (L1 C/A), Galileo (E1b/E1c), GLONASS, BeiDou
Signal Freq: 1575.42 MHz (L1), IF at 4.092 MHz, fs = 16.368 MHz
```

---

## Skills Demonstrated

- Full GNSS receiver chain: from raw measurements → spreading codes → IF signals → acquisition → tracking
- Statistical estimation: Least Mean Squares, Weighted LMS, multi-epoch fusion
- DSP fundamentals: FFT-based correlation, Welch PSD, digital filtering, complex baseband
- Multi-constellation processing: heterogeneous satellite fusion with noise weighting
- Real-world signal handling: live ephemeris retrieval, Android GnssLogger pipeline

---

*Academic project — Satellite Navigation Systems course, M.Sc. Communications Engineering.*
