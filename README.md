# Floristic Value Scoring App (June 2026)

A Shiny app that calculates a **Floristic Value Score (FVS)** from field survey
data, using an inventory of species in grassland bioregions around NSW.

## Repository structure

```
grasslands_final_2026_June/
├── Shiny_monaro.R          # Shiny UI + server (run this to launch the app)
├── monaro.R                # Reference list compilation + FVS calculation logic
├── Install_packages.R      # One-off script to install required R packages
├── Bionet_SpeciesNames.csv # BioNet species name / code lookup table
├── weight.csv              # Significance-rating x cover/abundance weighting table
├── reference_list.csv      # Compiled species reference list (see below) — downloadable
├── raw_data/                # Source spreadsheets used to build the reference list
│   ├── FVS_WVS_BBS_v1_2015_7_6.xlsx
│   ├── FVS_WVS_Riverina_v1_2015_8_12.xlsx
│   ├── FVS_WVS_SEH_Monaro_v2.0_2021_09_08.xlsx
│   ├── FVS_WVS_SEH_non-Monaro_v2.0_2021_01_15.xlsx
│   └── FVS_WVS_SWS_v2.0_RR_20220707.xlsx
└── www/                     # App images (logo, example screenshot)
```

### Reference list (`reference_list.csv`)

A reference list of species in the various grassland bioregions of NSW is
compiled from the spreadsheets in `raw_data/` (one per bioregion) and is used
internally by the app to score uploaded survey data. `reference_list.csv` in
the repo root is that compiled list, provided as a plain CSV for anyone who
wants to inspect or download it directly, with columns:

| Column | Description |
|---|---|
| `Scientific_Name` | Species name as it appears in the source bioregion spreadsheet |
| `sig` | Significance rating (see Rehwinkel, 2015) |
| `Bioregion` | Bioregion code (see table below) |
| `conditions` | Native/exotic status or cover-dependent scoring condition, where applicable |
| `speciesID` | BioNet `currentScientificNameCode` |
| `currentScientificName` | Current accepted scientific name per BioNet |
| `combo` | `speciesID` and `Bioregion` combined (e.g. `3626_BBS`) — the key used to match uploaded data against this reference list |

Changes to the reference list (e.g. altering species significance ratings or
adding new species) require editing the source spreadsheets in `raw_data/`
and re-running the compilation step in `monaro.R`, and should only be made by
an app administrator.

## To run the app in RStudio, locally on your machine

1. Download and unzip (or `git clone`) this repository.
2. Open RStudio and set your working directory to the unzipped/cloned folder
   (from the top menu: *Session > Set Working Directory > Choose Directory*,
   then navigate to the folder).
3. If it's your first time running the app, open `Install_packages.R` and
   click **Source**.
4. Open `Shiny_monaro.R`.
5. A button should appear in the top right of the script panel that says
   **Run App**. Click it and the app should open in a new window / your
   default web browser.

If you wish to publish the app for others to use, RStudio offers a free
hosting platform ([shinyapps.io](https://www.shinyapps.io/)).

## App quickstart guide

1. Click the **Data entry** tab.
2. Click **Browse** to access the file navigator on your device.
3. Navigate to your data file and click **Run**.
4. After assigning native/exotic/ignore status to species (if applicable),
   click **Calculate FVS**.
5. Finally, click **Download**.

Full explanations of each step are in the User Guide below.

## User guide

The app calculates a floristic value score from field survey data, using an
inventory of species in grassland bioregions around NSW.

The app homepage shows:

- A title, **Floristic Value Scoring** (referred to as FVS in this document).
- A tab on the top left of the page called **Data entry**.
- Instructions for how to prepare the uploaded spreadsheet for processing,
  with a screenshot of an example spreadsheet. **Note:** ensure you are using
  `speciesID` as the `Bionet_Species_Code` heading in the instructions — the
  2023 version used the `scientificNameIDcode` column from BioNet instead.

Bioregion codes are as follows:

| Code | Bioregion |
|---|---|
| `RIV` | Riverina |
| `MON` | Monaro |
| `SEH` | SEH non-Monaro |
| `NSS` | NSW South Western Slopes |
| `BBS` | Brigalow Belt South |

A reference list of species in the various grassland bioregions of NSW is
stored as part of the app (see [`reference_list.csv`](reference_list.csv)).
Each species has a significance rating as described in Rehwinkel (2015) and
their corresponding `currentScientificName` code for easy comparison with any
input data. Changes to this reference list, e.g. altering species
significance ratings or adding new species, can only be made by an app
administrator.

### Uploading data

1. Click the **Data entry** tab. A dropdown menu of buttons will appear.
2. Click **Browse** to access the file navigator on your device.
3. Navigate to the file and upload the data. The file name will appear in the
   window.

The homepage of the app has clear instructions on the data layout and content
required for the app to run, including a screenshot of the required column
headers. The order of the columns in your data is not important, but the
spelling of the column headers is — in particular, check for capital versus
lower case letters and extra spaces or underscores that may differ from those
in the instructions.

4. Navigate to your data file and click **Run**.

The file you selected is read into the app and an initial comparison is made
against the reference list. If any BioNet codes from your spreadsheet require
classification as native or exotic (i.e. are only identified to genus/family
level), a table will appear allowing you to assign species as:

- **native** — the species is known or likely to be native.
- **exotic** — the species is known or likely to be exotic.
- **Ignore in FVS calculation** — it is unknown whether the species is native
  or exotic, and it will be excluded from the FVS calculation for that plot.

If no native or exotic choices need to be made, the following message will
appear: *"There is no need to assign native or exotic status to any species
in this dataset."* You may proceed to the next step.

5. After assigning native/exotic/ignore status to species (if applicable),
   click **Calculate FVS**.

At this point an FVS score is generated for each plot, however the result is
not yet displayed. Instead, a table appears below the native/exotic
checkboxes listing species that will not be included, or whose name will be
changed, in the FVS calculation, for one of the following reasons:

- *"No value for cover was provided"* — there is a blank cell in the
  `Cover_%` column for that species. These species are excluded.
- *"No value for abundance was provided"* — there is a blank cell in the
  `Abundance` column AND the `Cover_%` column is less than 5. These species
  are excluded from the FVS calculation.
- *"No match for the scientific name at this location, consider synonyms"* —
  the BioNet code does not match any species in the reference for that
  grassland bioregion. It may be correctly identified and recorded in
  BioNet, but the current FVS reference list for the bioregion doesn't
  contain that species. These species are excluded from the FVS calculation.
- *"There are two observations for this species in the same plot"* — there
  are multiple different cover and/or abundance records for the same species
  in the same plot. These species are excluded from the FVS calculation. It
  is recommended that the dataset be updated to merge or remove one of these
  records before re-running the analysis.
- A name-change match — there was no direct match with the BioNet number but
  there was for the parent species of a variety or subspecies, e.g.
  *"Dianella revoluta var. revoluta will be changed to Dianella revoluta"*.
  These species are included in the calculation under the new name.

If none of the above apply to any species, the following message will
appear: *"Success. A significance rating has been assigned to all species."*

6. Finally, click **Download**.

A spreadsheet including the FVS, Weed Score and Native Species Richness
(number of native species) for each plot will be downloaded to your
designated downloads folder. The filename will include the current date and
time: `FVS_YYYYMMDD_HHMMSS.xlsx`.

> **Note:** Remember to refresh the page before uploading a new spreadsheet.

## Errors

If at any time an error message appears in red text at the bottom of the
screen, and nothing appears to be happening when one of the buttons is
pressed:

1. Refresh the page and try again.
2. Check the column headers of your data.
3. If the problem persists, send the data file with an explanation of the
   problem to the app administrator: dave.r.coleman@gmail.com.
