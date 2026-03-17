# creating an mRNA Cancer Vaccine - an end-to-end workflow

An architecture overview and operational pipeline for creating a personalized mRNA cancer vaccine. This repository maps the continuous "Code-to-Clinic" workflow, bridging raw biological patient data to a physically deliverable lipid nanoparticle (LNP) vaccine, including all necessary software, hardware, and reagents.

## Table of Contents
- [System Architecture](#system-architecture)
- [Part 1: Upstream Digital Pipeline (Data to Blueprint)](#part-1-upstream-digital-pipeline-data-to-blueprint)
- [Part 2: Downstream Physical Pipeline (Blueprint to Vial)](#part-2-downstream-physical-pipeline-blueprint-to-vial)
- [Hardware & Reagent Stack Summary](#hardware--reagent-stack-summary)

---

## System Architecture

This pipeline is divided into two continuous halves:
1. **Data to Blueprint:** Ingests raw sequencing data, utilizes neural networks to identify immunogenic targets, and compiles a stabilized digital mRNA sequence.
2. **Blueprint to Vial:** Converts the digital `.fasta` sequence into physical DNA, automates In Vitro Transcription (IVT), and formulates the final LNP drug product.

---

## Part 1: Upstream Digital Pipeline (Data to Blueprint)

### Phase 1: Reading the Blueprint (Digitizing the Cells)
**Goal:** Convert physical biological samples into unorganized genetic code to establish a baseline and identify tumor anomalies.
* **Hardware:** Next-Generation Sequencer (e.g., Illumina NovaSeq)
* **Inputs:** Tumor biopsy & Normal blood (healthy baseline).
* **Process:** The machine reads extracted DNA/RNA, turning biological chemistry into digital text.
* **Outputs:** Billions of short, unorganized genetic reads.
* **File Format:** `.fastq`
```text
@Machine_Read_ID_001
GATTTGGGGTTCAAAGCAGTATCGATCAAATAGTAAATCC
+
!''*((((***+))%%%++)(%%%%).1***-+*''))**
```

### Phase 2: Spotting the Typos (Finding the Mutations)
**Goal:** Compare the healthy code against the tumor code to isolate specific cancer-causing errors.
* **Software:** GATK Mutect2
* **Inputs:** Patient `.fastq` + Human Reference Genome.
* **Process:** Aligns reads and mathematically subtracts healthy DNA from tumor DNA to isolate somatic mutations.
* **Outputs:** A condensed list of specific genetic mutations.
* **File Format:** `.vcf` (Variant Call Format)
```text
#CHROM  POS       ID       REF  ALT  QUAL  FILTER  INFO
chr7    14045313  Mut_01   A    T    99    PASS    Somatic;TumorOnly
```

### Phase 3: Picking the Targets (AI Neoantigen Prediction)
**Goal:** Use AI to predict which mutations the immune system will recognize as a threat.
* **Software:** pVACseq running MHCflurry neural networks.
* **Inputs:** `.vcf` mutation list + Patient HLA profile.
* **Process:** Neural networks predict which mutations will most effectively trigger an immune response based on the patient's specific HLA receptors.
* **Outputs:** A ranked leaderboard of the best targets (neoantigens).
* **File Format:** `.tsv`
```text
Target_Rank  Peptide_Sequence  HLA_Type  Affinity_Score_nM
1            YLLPAIVHI         HLA-A*02  24.5
```

### Phase 4: Writing the New Code (Sequence Assembly)
**Goal:** Compile the top predicted targets into a single, printable digital blueprint.
* **Software:** pVACvector + LinearDesign
* **Inputs:** Top targets from `.tsv`.
* **Process:** Strings targets together, adds structural instructions (5' Cap, Poly-A tail), and optimizes codons for folding stability.
* **Outputs:** The master digital sequence of the mRNA vaccine.
* **File Format:** `.fasta` (The master manufacturing blueprint)
```text
>Patient_001_Custom_Vaccine_Construct_v1
AUGGGCUACUUGCUGCCAGCGAUUGUCCAUAUCCUCCUCUUCUUGGGCAAAAUUUGGCCG...
```

---

## Part 2: Downstream Physical Pipeline (Blueprint to Vial)

### Phase 5: Printing the Master Copy (DNA Synthesis)
**Goal:** Convert the digital blueprint back into a physical, readable linear DNA template.
* **Hardware:** Benchtop DNA Synthesizer (e.g., Telesis Bio BioXp 4400).
* **Inputs:** The `.fasta` file.
* **Process:** Automated Gibson Assembly stitches synthetic oligonucleotides into a complete DNA plasmid, which is then linearized with restriction enzymes (e.g., BspQI).
* **Outputs:** Physical, purified linear DNA template.
* **Key Reagents:** Oligonucleotides, BspQI restriction enzymes, AMPure XP purification beads.

### Phase 6: Mass Production (Automated mRNA Synthesis)
**Goal:** Execute the code by transcribing the DNA into functional, immune-cloaked mRNA.
* **Hardware:** NTxscribe System.
* **Inputs:** Linear DNA template + IVT Reagents.
* **Process:** Continuous-flow In Vitro Transcription (IVT) bioreactors read the DNA and print the corresponding mRNA strand.
* **Outputs:** Highly pure, naked mRNA.
* **Key Reagents:**
  * T7 RNA Polymerase (the "printer")
  * N1-methylpseudouridine (cloaking)
  * CleanCap® AG (human cell recognition)

### Phase 7: Packaging for Delivery (LNP Formulation)
**Goal:** Wrap the fragile mRNA in a protective lipid nanoparticle to allow human cell entry.
* **Hardware:** Unchained Labs Sunshine (Microfluidic Mixer) & Sunny Microfluidic Chips.
* **Inputs:** Purified mRNA + 4-Lipid Cocktail.
* **Process:** Precise microfluidic collisions force the negatively charged mRNA and positively charged lipids to self-assemble into nanoparticles.
* **Outputs:** Formulated mRNA Lipid Nanoparticles (LNPs).
* **Key Reagents:** Ionizable Lipid (e.g., ALC-0315), PEG-Lipid, DSPC (Helper Lipid), Cholesterol, Ethanol, Acidic Buffer.

### Phase 8: Quality Check & Bottling (QC & Finalization)
**Goal:** Validate structural integrity, size, and concentration before finalizing for injection.
* **Hardware:** Unchained Labs Stunner & TFF System.
* **Inputs:** Raw mRNA-LNP mixture.
* **Process:**
  * **Stunner:** Dynamic Light Scattering (DLS) verifies particles are exactly 60–100nm.
  * **TFF:** Tangential Flow Filtration washes out the toxic ethanol used during mixing.
* **Outputs:** Final, injectable, personalized cancer vaccine suspended in a cryoprotectant.
* **Key Reagents:** Tris-Sucrose Buffer (cryoprotectant), RiboGreen Assay (encapsulation verification).

---

## Hardware & Reagent Stack Summary

| Subsystem | Primary Hardware | Core Consumables |
| --- | --- | --- |
| Sequencing | Illumina NovaSeq | Extraction Kits, Flow Cells |
| DNA Prep | Telesis Bio BioXp | Gibson Kits, AMPure XP Beads |
| mRNA Synth | NTxscribe | T7 Polymerase, Mod-NTPs, CleanCap |
| LNP Mix | Unchained Labs Sunshine | Sunny Chips, 4-Lipid Cocktail |
| Validation | Unchained Labs Stunner | Stunner Plates, RiboGreen Assay |