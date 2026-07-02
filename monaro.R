####### README #########

# compile ref involves 

# process of calculating Floristic Value Score
library(readxl)
library(tidyverse)

# Compile the reference list

files = list.files(path = "raw_data", pattern = "FVS_WVS", full.names = TRUE)

compile_ref = function(x){
  
  #read in and select columns
  df = read_excel(x, sheet = 3)
  df = df[,names(df)[str_detect(names(df), "^SCIENT|Significance Rating$")]]
  names(df) = c("Scientific_Name", "sig")
  
  # display the bioregion from the filename (strip any directory path first)
  df$Bioregion = gsub("_v[0-9].*", "", basename(x))
  df$Bioregion = gsub("FVS_WVS_", "", df$Bioregion)
  df$Bioregion = gsub("Riverina", "RIV", df$Bioregion)
  df$Bioregion = gsub("SEH_Monaro", "MON", df$Bioregion)
  df$Bioregion = gsub("SEH_non-Monaro", "SEH", df$Bioregion)
  df$Bioregion = gsub("SWS", "NSS", df$Bioregion)
  
  # clean the sig column
  df$sig = gsub("No score", "*", df$sig)
  df = df %>% filter(sig != "end") %>% filter(!is.na(Scientific_Name))
  df$sig = str_to_upper(df$sig)
  
  # move the stuff in brackets to a new column and extract the conditions
  df$conditions = str_extract(df$Scientific_Name, "(cover of less than 25%; C/A score of 4 or lower)|(cover of 25% or greater; C/A score of 5 or higher)|(cover of 25% or more; C/A score of 5 or higher)|(5% or >)|(< 5%)")
  df$conditions = ifelse(str_detect(df$Scientific_Name, "native|\\(indigenous|\\(C\\. inversa|\\(part of the natural population|\\(locally indigenous"), "Native", df$conditions)
  df$conditions = ifelse(str_detect(df$Scientific_Name, "exotic|non-indigenous|not locally indigenous|derived from escaped|escaped"), "Exotic", df$conditions)
  df$Scientific_Name = gsub("\\(.*", "", df$Scientific_Name)
  
  ###### Needs to be fixed! #### Right now, we are not including any of these native/exotic distinctions
#  df$sig[df$Scientific_Name %in% df$Scientific_Name[which(duplicated(df[,-2]))]] = "*"
  
  # change syntax
  df$Scientific_Name = str_trim(df$Scientific_Name)
  df$Scientific_Name = gsub("sp\\.$", "spp\\.", df$Scientific_Name)
  df$Scientific_Name = str_trim(df$Scientific_Name)
  
  #spelling
  df$Scientific_Name = gsub("Arthropodium species B", "Arthropodium sp. B", df$Scientific_Name)
  df$Scientific_Name = gsub("Acacia aureocrinia", "Acacia aureocrinita", df$Scientific_Name)
  df$Scientific_Name = gsub("Adiantum aethiopica", "Adiantum aethiopicum", df$Scientific_Name)
  df$Scientific_Name = gsub("Aira caryophylla", "Aira caryophyllea", df$Scientific_Name)
  df$Scientific_Name = gsub("Alternanthera sp.A", "Alternanthera sp. A", df$Scientific_Name)
  df$Scientific_Name = gsub("Alternanthers denticulata", "Alternanthera denticulata", df$Scientific_Name)
  df$Scientific_Name = gsub("Anternanthera nana", "Alternanthera nana", df$Scientific_Name)
  df$Scientific_Name = gsub("Anthosachne scaber", "Anthosachne scabra", df$Scientific_Name)
  df$Scientific_Name = gsub("Anthoxanthum oderatum", "Anthoxanthum odoratum", df$Scientific_Name)
  df$Scientific_Name = gsub("Arrhenechthites mixtus", "Arrhenechthites mixta", df$Scientific_Name)
  df$Scientific_Name = gsub("Baekia utilis|Baeckia utilis", "Baeckea utilis", df$Scientific_Name)
  df$Scientific_Name = gsub("Boerharvia dominii", "Boerhavia dominii", df$Scientific_Name)
  df$Scientific_Name = gsub("Botrichium australe", "Botrychium australe", df$Scientific_Name)
  df$Scientific_Name = gsub("Bromus hordaceus", "Bromus hordeaceus", df$Scientific_Name)
  df$Scientific_Name = gsub("Calotis sp$", "Calotis spp.", df$Scientific_Name)
  df$Scientific_Name = gsub("Carex gaudichaudii", "Carex gaudichaudiana", df$Scientific_Name)
  df$Scientific_Name = gsub("Carex inyx", "Carex iynx", df$Scientific_Name)
  df$Scientific_Name = gsub("Carex longebractiata", "Carex longebrachiata", df$Scientific_Name)
  df$Scientific_Name = gsub("Centipida spp.", "Centipeda spp.", df$Scientific_Name)
  df$Scientific_Name = gsub("Centrella cordifolia", "Centella cordifolia", df$Scientific_Name)
  df$Scientific_Name = gsub("Cheilanthes sieberi subspecies sieberi", "Cheilanthes sieberi subsp. sieberi", df$Scientific_Name)
  df$Scientific_Name = gsub("Coronidium gunnii", "Coronidium gunnianum", df$Scientific_Name)
  df$Scientific_Name = gsub("Dichantheum sericeum", "Dichanthium sericeum", df$Scientific_Name)
  df$Scientific_Name = gsub("Dichelanchne crinita", "Dichelachne crinita", df$Scientific_Name)
  df$Scientific_Name = gsub("Dichondra sp.A", "Dichondra sp. A", df$Scientific_Name)
  df$Scientific_Name = gsub("Eragrotis basedowii", "Eragrostis basedowii", df$Scientific_Name)
  df$Scientific_Name = gsub("Eragrotis setifolia", "Eragrostis setifolia", df$Scientific_Name)
  df$Scientific_Name = gsub("Eucalyptus teretecornis", "Eucalyptus tereticornis", df$Scientific_Name)
  df$Scientific_Name = gsub("Eucalytpus spp.", "Eucalyptus spp.", df$Scientific_Name)
  df$Scientific_Name = gsub("Genista liifolia", "Genista linifolia", df$Scientific_Name)
  df$Scientific_Name = gsub("Gompholobium huegellii", "Gompholobium huegelii", df$Scientific_Name)
  df$Scientific_Name = gsub("Hydrocotyle calicarpa", "Hydrocotyle callicarpa", df$Scientific_Name)
  df$Scientific_Name = gsub("Imperata cylindica", "Imperata cylindrica", df$Scientific_Name)
  df$Scientific_Name = gsub("Juncus arcutus", "Juncus acutus", df$Scientific_Name)
  df$Scientific_Name = gsub("Lachnogrostis filiformis", "Lachnagrostis filiformis", df$Scientific_Name)
  df$Scientific_Name = gsub("Lepidium fascicularis", "Lepidium fasciculatum", df$Scientific_Name)
  df$Scientific_Name = gsub("Lepidium ginninderense", "Lepidium ginninderrense", df$Scientific_Name)
  df$Scientific_Name = gsub("Leptorhynchos sp,", "Leptorhynchos spp.", df$Scientific_Name)
  df$Scientific_Name = gsub("Levenhoekia dubia", "Levenhookia dubia", df$Scientific_Name)
  df$Scientific_Name = gsub("Liliopsis polyantha", "Lilaeopsis polyantha", df$Scientific_Name)
  df$Scientific_Name = gsub("Medicago lacinata", "Medicago laciniata", df$Scientific_Name)
  df$Scientific_Name = gsub("Medigaco spp.", "Medicago spp.", df$Scientific_Name)
  df$Scientific_Name = gsub("Muelenbeckia axilaris", "Muehlenbeckia axillaris", df$Scientific_Name)
  df$Scientific_Name = gsub("Nicotinia megalosiphon", "Nicotiana megalosiphon", df$Scientific_Name)
  df$Scientific_Name = gsub("Onorpodum acanthium", "Onopordum acanthium", df$Scientific_Name)
  df$Scientific_Name = gsub("Ophioglossum lusitaniacum", "Ophioglossum lusitanicum", df$Scientific_Name)
  df$Scientific_Name = gsub("Persoonia chamaecyce", "Persoonia chamaepeuce", df$Scientific_Name)
  df$Scientific_Name = gsub("Platylobium formosa", "Platylobium formosum", df$Scientific_Name)
  df$Scientific_Name = gsub("Proboscidea louisiana", "Proboscidea louisianica", df$Scientific_Name)
  df$Scientific_Name = gsub("Ptilotus exalatus", "Ptilotus exaltatus", df$Scientific_Name)
  df$Scientific_Name = gsub("Scleranthus anuus", "Scleranthus annuus", df$Scientific_Name)
  df$Scientific_Name = gsub("Sclerolaena lanicuspus", "Sclerolaena lanicuspis", df$Scientific_Name)
  df$Scientific_Name = gsub("Sida cunninghami$", "Sida cunninghamii", df$Scientific_Name)
  df$Scientific_Name = gsub("Stenotaphrum secundum", "Stenotaphrum secundatum", df$Scientific_Name)
  df$Scientific_Name = gsub("Swiansona behriana", "Swainsona behriana", df$Scientific_Name)
  df$Scientific_Name = gsub("Thesium australis", "Thesium australe", df$Scientific_Name)
  df$Scientific_Name = gsub("Tribulus terestris", "Tribulus terrestris", df$Scientific_Name)
  df$Scientific_Name = gsub("Xanthorrhroea spp.", "Xanthorrhoea spp.", df$Scientific_Name)
  df$Scientific_Name = gsub("Gypsophylla tubulosa", "Gypsophila tubulosa", df$Scientific_Name)
  df$Scientific_Name = gsub("sp\\.\\.", "spp\\.", df$Scientific_Name)  
  
  
  df$Scientific_Name = gsub("Poaceae", "Poaceae indeterminate", df$Scientific_Name)
  
  # Name changes
  df$Scientific_Name = gsub("Arthropodium strictum", "Dichopogon strictus", df$Scientific_Name)
  df$Scientific_Name = gsub("Callistachys procumbens", "Oxylobium procumbens", df$Scientific_Name)
  df$Scientific_Name = gsub("Grona varians", "Desmodium varians", df$Scientific_Name)
  df$Scientific_Name = gsub("Nasturtium officinale", "Rorippa nasturtium-aquaticum", df$Scientific_Name)
  df$Scientific_Name = gsub("Oxylobium oxylobioides", "Mirbelia oxylobioides", df$Scientific_Name)
  df$Scientific_Name = gsub("Pelargonium littorale", "Pelargonium helmsii", df$Scientific_Name)
  df$Scientific_Name = gsub("Poterium polygamum", "Sanguisorba minor", df$Scientific_Name)
  df$Scientific_Name = gsub("Pullenia gunnii", "Desmodium gunnii", df$Scientific_Name)
  df$Scientific_Name = gsub("Sclerolaena paradoxa", "Dissocarpus paradoxus", df$Scientific_Name)
  df$Scientific_Name = gsub("Teucrium sp. A sensu Conn", "Teucrium sp. A", df$Scientific_Name)
  df$Scientific_Name = gsub("Cenchrus spinifex", "Cenchrus incertus", df$Scientific_Name)
  df$Scientific_Name = gsub("Anthosachne plurinervis", "Agropyron scabrum var. plurinerve", df$Scientific_Name)
  # BUG FIX #3: Removed self-defeating substitution chain. Previously, "Rytidosperma bipartita"
  # was renamed to "Austrodanthonia bipartitum", then immediately renamed again to
  # "Austrodanthonia bipartita". The intended final name is "Austrodanthonia bipartita",
  # so the intermediate step is removed. "Austrodanthonia linkii" was also removed as
  # it was a duplicate of the "Rytidosperma linkii" -> "Rytidosperma bipartitum" rule below.
  df$Scientific_Name = gsub("Rytidosperma bipartita", "Austrodanthonia bipartita", df$Scientific_Name)
  df$Scientific_Name = gsub("Rytidosperma caespitosa", "Rytidosperma caespitosum", df$Scientific_Name)
  df$Scientific_Name = gsub("Rytidosperma leave", "Rytidosperma laeve", df$Scientific_Name)
  df$Scientific_Name = gsub("Rytidosperma tenuior", "Rytidosperma tenuius", df$Scientific_Name)
  df$Scientific_Name = gsub("Euphorbia drummondii", "Chamaesyce drummondii", df$Scientific_Name)
  
  #advised by review team
  df$Scientific_Name = gsub("Dianella sp. aff. longifolia", "Dianella longifolia var. longifolia", df$Scientific_Name)
  df$Scientific_Name = gsub("Grevillea sp. aff. alpina", "Grevillea alpina", df$Scientific_Name)
  df$Scientific_Name = gsub("Hibiscus tridactylites", "Hibiscus trionum var. trionum", df$Scientific_Name)
  df$Scientific_Name = gsub("Miniura sp.", "Minuria sp.", df$Scientific_Name)
  df$Scientific_Name = gsub("Prasophyllum sp. aff. occidentale D", "Prasophyllum sp. Moama", df$Scientific_Name)
  df$Scientific_Name = gsub("Rytidosperma linkii", "Rytidosperma bipartitum", df$Scientific_Name)
  df$Scientific_Name = gsub("Muscari racemosum", "Muscari armeniacum", df$Scientific_Name)
  df$Scientific_Name = gsub("Phalaris annua", "Phalaris aquatica", df$Scientific_Name)
  #delete species unrecognised by bionet
  df = df %>% filter(!Scientific_Name %in% c("Cassinia cuneata", #unknown sp
                                             "Diuris protena", #victoria only
                                             "Ligustrum ovatum", # Garden plant
                                             "Lomandra sororia", #victoria only
                                             "Marsdenia angustifolia", #Garden plant
                                            # "Muscari racemosum", # Garden plant
                                            # "Phalaris annua", #unknown species
                                             "Pimelea spinescens", #victoria only
                                             "Rytidosperma geniculatum", #victoria only
                                             "Rubiaceaeae indeterminate"
                                             )) 
  
  # fix the two significance errors:
  df$sig[df$Scientific_Name == "Levenhookia dubia"] = "A"
  df$sig[df$Scientific_Name == "Anthosachne scabra"] = "C"
  
  
  
  return(df)
}


# run the function
raw = lapply(files, compile_ref)

#make the dataframe
ref = bind_rows(raw)
#################################################################################
#

Bio = read.csv("Bionet_SpeciesNames.csv")
# Use currentScientificNameCode as the species ID so that user data with either
# old or current codes is matched against the current Bionet standard.
Bio = Bio %>% mutate(speciesID = currentScientificNameCode)

# merge in a Bionet scientificName and current ScientificName
ref1 = merge(ref, Bio %>% select( scientificName, speciesID, currentScientificName) %>% unique(), by.x = "Scientific_Name", by.y = "scientificName", all.x = T)
ref1 = unique(ref1)
ref1 = ref1 %>% mutate(combo = str_c(speciesID, "_", Bioregion))

# When multiple scientific names share the same BioNet speciesID (taxonomic synonyms),
# the merge in deal_with_conditions would produce duplicate rows for any matched species.
# Deduplicate on (speciesID, Bioregion, conditions), keeping the lower-scoring sig
# (C < B < A for natives; Z < Y < X for exotics) to be conservative.
sig_order <- c("C", "Z", "B", "Y", "A", "X", "*")
ref1 <- ref1 |>
  mutate(sig_rank = match(sig, sig_order, nomatch = length(sig_order) + 1L)) |>
  group_by(speciesID, Bioregion, conditions) |>
  slice_min(sig_rank, n = 1, with_ties = FALSE) |>
  ungroup() |>
  select(-sig_rank)


deal_with_native_exotic = function(data){
  
  # Get the natives and exotics
  n_e = ref1 %>% filter(conditions == "Native"| conditions == "Exotic")
  
  # get the neutrals too
  n_e1 = ref1 %>% filter(combo %in% n_e$combo)
  
  # BUG FIX #2: The UI instructs users to name the column "Bionet_Species_Code", but
  # internally the code expects "Species_Code_Bionet". Rename only if needed, so both
  # column naming conventions are accepted.
  if ("Bionet_Species_Code" %in% names(data) && !"Species_Code_Bionet" %in% names(data)) {
    data = data %>% rename(Species_Code_Bionet = Bionet_Species_Code)
  }
  
  # get the species 
  data1 = data %>% mutate(combo = str_c(Species_Code_Bionet, "_", Bioregion))
  
  # create the possible options for the relevant location Plot_IDs: native, neutral or exotic
  choices = n_e1 %>% filter(combo %in% data1$combo) %>% 
    merge(data1 %>% select(Species_Code_Bionet, Plot_ID), by.x = "speciesID" , by.y = "Species_Code_Bionet" ) %>% 
    arrange(Plot_ID)
  
  #make the NAs into ""
  choices$conditions[is.na(choices$conditions)] = "Ignore in FVS calculation"
  
  # create an output column to display on the checkboxes
  choices = choices %>% select(Plot_ID, Scientific_Name, Bioregion, conditions) %>%  
    unite(output, Plot_ID:Bioregion, sep = " | ", remove = F) 
  
  # BUG FIX #1: Added missing return() — without this the function returned NULL,
  # meaning the native/exotic radio button table never populated in the Shiny app.
  return(choices)
  
}

################################################################################
deal_with_conditions = function(data){
  
  # Normalise column name: UI instructs "Bionet_Species_Code" but internal code
  # expects "Species_Code_Bionet". Rename if needed so both conventions work.
  if ("Bionet_Species_Code" %in% names(data) && !"Species_Code_Bionet" %in% names(data)) {
    data = data %>% rename(Species_Code_Bionet = Bionet_Species_Code)
  }
  
# assign species to the reference list based on their coverage
above1 = ref1[which(str_detect(ref1$conditions, "25\\% or more")),]
above1 = above1 %>% mutate(combo = str_c(Scientific_Name, Bioregion))

if("conditions" %in% names(data)){
  
  data = data %>% mutate(conditions = ifelse(str_c(Scientific_Name, Bioregion) %in% above1$combo &`Cover_%` >= 25, "cover of 25% or more; C/A score of 5 or higher", conditions))

  }else{

data = data %>% mutate(conditions = ifelse(str_c(Scientific_Name, Bioregion) %in% above1$combo &`Cover_%` >= 25, "cover of 25% or more; C/A score of 5 or higher", NA))

}

above2 = ref1[which(str_detect(ref1$conditions, "25\\% or greater")),]
above2 = above2 %>% mutate(combo = str_c(Scientific_Name, Bioregion))
data = data %>% mutate(conditions = ifelse(str_c(Scientific_Name, Bioregion) %in% above2$combo &`Cover_%` >= 25, "cover of 25% or greater; C/A score of 5 or higher", conditions))

above3 = ref1[which(str_detect(ref1$conditions, "5% or >")),]
above3 = above3 %>% mutate(combo = str_c(Scientific_Name, Bioregion))
data = data %>% mutate(conditions = ifelse(str_c(Scientific_Name, Bioregion) %in% above3$combo &`Cover_%` >= 5, "5% or >", conditions))


below1 = ref1[which(str_detect(ref1$conditions, "less than 25\\%")),]
below1 = below1 %>% mutate(combo = str_c(Scientific_Name, Bioregion))
data = data %>% mutate(conditions = ifelse(str_c(Scientific_Name, Bioregion) %in% below1$combo &`Cover_%` < 25, "cover of less than 25%; C/A score of 4 or lower", conditions))

below2 = ref1[which(str_detect(ref1$conditions, "< 5%")),]
below2 = below2 %>% mutate(combo = str_c(Scientific_Name, Bioregion))
data = data %>% mutate(conditions = ifelse(str_c(Scientific_Name, Bioregion) %in% below2$combo &`Cover_%` < 5, "< 5%", conditions))

# this is where the data is first merged with the reference list
ref1_merge = ref1 %>% mutate(conditions = replace_na(as.character(conditions), "none"))
data_merge = data %>% mutate(conditions = replace_na(as.character(conditions), "none"))
data_merge = merge(data_merge, ref1_merge %>% select(-Scientific_Name), by.x = c("Species_Code_Bionet", "Bioregion", "conditions"), by.y = c("speciesID", "Bioregion", "conditions"), all.x = T)
data = data_merge %>% mutate(conditions = na_if(conditions, "none"))

data = unique(data)

}

################################################################################
error_lists = function(data){
  
  # recreate and bind back on any name changes
  # get any names that didn't match
  no_match = data %>% filter(is.na(sig)) %>% select(Plot_ID, Bioregion, Species_Code_Bionet, conditions, Scientific_Name, `Cover_%`, Abundance)
  #create a new name without the subsp 
  no_match$Scientific_Name_new = gsub(" var\\..*| subsp\\..*", "", no_match$Scientific_Name)
  
  # also change the species codes on these 
  no_match = merge(no_match %>% select(-Species_Code_Bionet), Bio %>% select(scientificName, currentScientificName, speciesID), by.x = "Scientific_Name_new", by.y = "scientificName", all.x = T) %>% unique()
  no_match = no_match %>% mutate(Species_Code_Bionet = speciesID) %>% select(-speciesID)
  
  # merge with the reference list to see if they match
  no_match_new = merge(no_match, ref1 %>% select(-Scientific_Name), by.x = c("Species_Code_Bionet", "Bioregion", "conditions"), by.y = c("speciesID", "Bioregion", "conditions"), all.x = T)
  
  # for any of the changes that resulted in a match, create the warning message
  change = no_match_new %>% filter(!is.na(sig)) %>% mutate(Warning = str_c(Scientific_Name, " will be changed to ", Scientific_Name_new)) #
  
  # sore the mini table for rbinding at the end of the function
  change = change %>% select(Bioregion, Plot_ID, Scientific_Name, Warning)
  # take out these rows so they dont throw other errors
  data = data %>% filter(!Scientific_Name %in% change$Scientific_Name)
  # look for non-matching names
  name_match = data %>% filter(is.na(sig)) %>% select(Bioregion, Plot_ID, Scientific_Name)
 
 if (nrow(name_match) >0){
 name_match$Warning = "No match for the scientific name at this location, consider synonyms"
 }else{
   name_match$Warning = character()
 }
 
  # missing abundances
 missing_abundance = data[is.na(data$Abundance)&data$`Cover_%` < 5,] %>% select(Bioregion, Plot_ID, Scientific_Name)
 
 if (nrow(missing_abundance) >0){
 missing_abundance$Warning = "No value for abundance was provided"
 }else{
   missing_abundance$Warning = character()
 }
 
 # missing cover
 missing_cover = data[is.na(data$`Cover_%`),] %>% select(Bioregion, Plot_ID, Scientific_Name)
 
 if (nrow(missing_cover) > 0){
 missing_cover$Warning = "No value for cover was provided"
 }else{
   missing_cover$Warning = character()
 }
 
 # any species that appear twice in the same lot
 duplicated_ID = data %>% group_by(Species_Code_Bionet, Plot_ID) %>% filter(n()>1) %>% ungroup() #%>% select(Bioregion, Plot_ID, Scientific_Name)
 duplicated_ID1 = duplicated_ID %>% select(Plot_ID, Scientific_Name, `Cover_%`, Abundance) %>%  unique() %>% group_by(Scientific_Name) %>% filter(n()>1)
 duplicated_ID = duplicated_ID %>% select(Bioregion, Plot_ID, Scientific_Name) %>% filter(Scientific_Name %in% duplicated_ID1$Scientific_Name)%>% unique()
 
 if (nrow(duplicated_ID1) > 0){
   duplicated_ID$Warning = "There are two observations for this species in the same plot"
 }else{
   duplicated_ID$Warning = character()
 }
 
 # 
 #create the warnings table
 
 excluded_data = rbind(change, name_match, missing_abundance, missing_cover, duplicated_ID)
 excluded_data = excluded_data %>% filter(!is.na(Scientific_Name))
 
 return(excluded_data)
}


############################################
# Ready to calculate the score

# read in weights and name changes
weight = read.csv("weight.csv")

calculate_FVS = function(data1){
 
  
# remove no species matches AND missing data
data1 = data1 %>% filter(!(is.na(sig) & is.na(Abundance)))
data1 = data1 %>% filter(!(is.na(sig) & is.na(`Cover_%`)))

# recreate and bind back on any name changes
# get any names that didn't match
no_match = data1 %>% filter(is.na(sig)) %>% select(Plot_ID, Bioregion, Species_Code_Bionet, conditions, Scientific_Name, `Cover_%`, Abundance)
#create a new name without the subsp 
no_match$Scientific_Name_new = gsub(" var\\..*| subsp\\..*", "", no_match$Scientific_Name)

# also change the species codes on these 
no_match = merge(no_match %>% select(-Species_Code_Bionet), Bio %>% select(scientificName, currentScientificName, speciesID), by.x = "Scientific_Name_new", by.y = "scientificName", all.x = T) %>% unique()
no_match = no_match %>% mutate(Species_Code_Bionet = speciesID) %>% select(-speciesID, -currentScientificName)

# merge with the reference list to see if they match
no_match_new = merge(no_match, ref1 %>% select(-Scientific_Name), by.x = c("Species_Code_Bionet", "Bioregion", "conditions"), by.y = c("speciesID", "Bioregion", "conditions"), all.x = T) %>% 
               filter(!is.na(sig)) %>% 
               mutate(Scientific_Name = Scientific_Name_new) %>% 
               select(-Scientific_Name_new)
  

# Take out all errors — do this BEFORE rbinding name-change fixes (BUG FIX #5)
# to prevent no_match_new rows from being duplicated: error_lists() also processes
# these rows and would otherwise include them in its change warnings AND they'd be
# added again via rbind below.
y = error_lists(data1)
y = y %>% mutate(combo1 = str_c(Plot_ID, Scientific_Name, sep = " "))
data1 = data1 %>% mutate(combo1 = str_c(Plot_ID, Scientific_Name, sep = " "))
data1 = data1 %>% filter(!combo1 %in% y$combo1) %>% filter(sig != "*") %>% select(-combo1)
# take out the *

#add back in the successful name changes (moved after error filtering — see Bug Fix #5)
data1 = rbind(data1, no_match_new)
data1 = unique(data1)
# assign the 1-7 standards here
data1 = data1 %>% mutate(cov_abun = ifelse(`Cover_%` < 5 & Abundance < 4, 1, NA))
data1 = data1 %>% mutate(cov_abun = ifelse(`Cover_%` < 5 & Abundance <= 15 & Abundance >= 4, 2, cov_abun))
data1 = data1 %>% mutate(cov_abun = ifelse(`Cover_%` < 5 & Abundance > 15, 3, cov_abun))
data1 = data1 %>% mutate(cov_abun = ifelse(`Cover_%` >= 5 & `Cover_%` <= 25, 4, cov_abun))
data1 = data1 %>% mutate(cov_abun = ifelse(`Cover_%` > 25 & `Cover_%` <= 50, 5, cov_abun))
data1 = data1 %>% mutate(cov_abun = ifelse(`Cover_%` > 50 & `Cover_%` < 75, 6, cov_abun))
data1 = data1 %>% mutate(cov_abun = ifelse(`Cover_%` >= 75, 7, cov_abun))

# test to see what the scores for native are currently


#########################

# incorporate the conditions column statement.. if these species have a score of less than or equal to 5, it should equal 5

data1$cov_abun[which(str_detect(data1$conditions, "25% or more|25% or greater")& data1$`Cover_%` >= 25)] = ifelse(data1$cov_abun[which(str_detect(data1$conditions, "25% or more|25% or greater")& data1$`Cover_%` >= 25)] <= 5, 5, data1$cov_abun[which(str_detect(data1$conditions, "25% or more|25% or greater")& data1$`Cover_%` >= 25)])



data1$cov_abun[which(str_detect(data1$conditions,"less than 25\\%")& data1$`Cover_%` < 25)] = ifelse(data1$cov_abun[which(str_detect(data1$conditions,"less than 25\\%")& data1$`Cover_%` < 25)] >= 4, 4, data1$cov_abun[which(str_detect(data1$conditions,"less than 25\\%")& data1$`Cover_%` < 25)])


# Prepare the categories for the weighting multiplier
scores = data1 %>% mutate(cov_abun_cat = ifelse(cov_abun >= 3, "3 to 7", cov_abun))

scores2 = scores %>% group_by(Plot_ID, Bioregion, sig, cov_abun_cat) %>% summarise(count = n())

scores2 = scores2 %>% mutate(native = ifelse(sig %in% c("A", "B", "C"), "native", "non_native"))

scores3 = merge(scores2, weight, by.x = c("sig", "cov_abun_cat"), by.y = c("sig", "cov_abun"), all.x = T)

# Calculate the scores
scores3 = scores3 %>% mutate(FVS_weight = count*weighting)

# and sum to get the FVS and the weed score
out = scores3 %>% group_by(Plot_ID, Bioregion, native) %>% summarise(FVS = sum(FVS_weight))

#Special conditions for each site
MON = data1 %>% filter(Bioregion == "MON" & Scientific_Name %in% c("Carex bichenoviana", "Themeda triandra") & `Cover_%` >= 75)

SEH = data1 %>% filter(Bioregion == "SEH" & Scientific_Name %in% c("Carex bichenoviana", "Themeda triandra") & `Cover_%` >= 75)

NSS = data1 %>% filter(Bioregion == "NSS" & Scientific_Name %in% c("Themeda triandra") & `Cover_%` >= 75)

BBS = data1 %>% filter(Bioregion == "BBS" & Scientific_Name %in% c("Austrostipa aristiglumis", "Dichanthium sericeum", "Microlaena stipoides",
                                                                   "Panicum decompositum", "Paspalidium jubiflorum", "Poa sieberiana",
                                                                   "Poa labillardierei", "Sorghum leiocladum", "Triodia mitchellii") | str_detect(Scientific_Name, "Astrebla|Cymbopogon|Enteropogon|Themeda")) %>% filter( `Cover_%` >= 75)

RIV = data1 %>% filter(Bioregion == "RIV" & (Scientific_Name %in% c("Rytidosperma caespitosum", 
                                                                   "Austrostipa aristiglumis",
                                                                   "Rytidosperma duttonianum" ) | str_detect(Scientific_Name, "Enteropogon"))) %>% filter(`Cover_%` >= 75) # BUG FIX #4: Added parentheses to fix operator precedence — previously the Bioregion check did not apply to str_detect(Enteropogon)

extra = rbind(MON, SEH, NSS, BBS, RIV)

out = out %>% mutate(FVS = ifelse(Plot_ID %in% extra$Plot_ID & native == "native", FVS + 1, FVS))


# Make the output!
out1 = pivot_wider(out, names_from =native, values_from = FVS)



richness = scores3 %>% filter(sig %in% c("A", "B", "C")) %>% group_by(Plot_ID) %>% summarise(richness = sum(count))

if (!"native" %in% names(out1)){
  out1$native = ""
  
}

if (!"non_native" %in% names(out1)){
  out1$non_native = ""
}



out2 = merge(out1, richness, by = "Plot_ID", all.x = T) %>% select(Bioregion, Plot_ID, native, non_native, richness)

names(out2) = c("Bioregion", "Plot_ID", "FVS", "Weed score", "Native Species Richness")

out2 = out2 %>% select(Plot_ID, Bioregion, FVS:`Native Species Richness`)

if (is.numeric(out2$FVS)){
out2$FVS = signif(out2$FVS, 3)
}

if(is.numeric(out2$`Weed score`)){
out2$`Weed score` = signif(out2$`Weed score`, 3)
}

return(out2)

}

# Comment these out!! #######################################################################
     # data = read_excel("FVS_example_data.xlsx")
     # x = deal_with_native_exotic(data)
     # data1 = deal_with_conditions(data)
     # warnings = error_lists(data1)
     # out = calculate_FVS(data1)



