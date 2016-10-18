################################################## START OF LICENSE ##################################################
#
#  This file is part of the emMorph / Humor morphological analyzer description for Hungarian.
#  Copyright (C) 2001-2016 Attila Novák
#  
#  The author of the database and the database compilation environment is Attila Novák (novakat@gmail.com).
#  The resource is available from: https://github.com/dlt-rilmta/emMorph
#  
#  The database files are licensed under the Creative Commons Attribution-NonCommercial-ShareAlike 4.0
#  (CC BY-NC-SA) license, the compilation scripts under the GNU General Public License (GPL v3)
#  with the following amendments:
#  
#  By downloading/cloning/using this database and tools you accept the following terms:
#  
#  1. Please inform the author at [novakat@gmail.com](mailto:novakat@gmail.com) about your use of the database/tools
#  clearly indicating what you use this database or tool for in your application/experiment/resource.
#  
#  2. If possible, please publish a scientific paper about each application, experimental system
#  or linguistic resource you create or experiment you perform using this resource quoting the articles below,
#  and inform the author at [novakat@gmail.com](mailto:novakat@gmail.com) about each article you publish. 
#  
#  Articles to quote are listed at https://github.com/dlt-rilmta/emMorph, the list is currently the following:
#  (See the BibTeX file quotethis.bib in the root directory):
#  
#  Attila Novák (2014): A New Form of Humor – Mapping Constraint-Based Computational Morphologies to a Finite-State Representation.
#  In: Proceedings of the 9th International Conference on Language Resources and Evaluation (LREC-2014). Reykjavík, pp. 1068–1073 (ISBN 978-2-9517408-8-4)
#  
#  Attila Novák; Borbála Siklósi; Csaba Oravecz (2016): A New Integrated Open-source Morphological Analyzer for Hungarian
#  In: Proceedings of the Tenth International Conference on Language Resources and Evaluation (LREC 2016). Portorož, pp. 1315–1322.
#  
#  Novák Attila (2003): Milyen a jó Humor? [What is good Humor like?] In: Magyar Számítógépes Nyelvészeti Konferencia (MSZNY 2003). Szegedi Tudományegyetem, pp. 138–145
#  
#  3. Please do share your adaptations of the morphology (vocabulary extensions etc.) using the same licenses.
#  
#  4. If you are interested in using or adapting the resource for commercial purposes, please contact the author.
#  ***
#  
#  The Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA)
#  license is available at: https://creativecommons.org/licenses/by-nc-sa/4.0/
#  
#  Disclaimer of Warranties and Limitation of Liability.
#  
#  Unless otherwise separately undertaken by the Licensor, to the extent possible,
#  the Licensor offers the Licensed Material as-is and as-available, and makes no
#  representations or warranties of any kind concerning the Licensed Material,
#  whether express, implied, statutory, or other. This includes, without
#  limitation, warranties of title, merchantability, fitness for a particular
#  purpose, non-infringement, absence of latent or other defects, accuracy, or the
#  presence or absence of errors, whether or not known or discoverable. Where
#  disclaimers of warranties are not allowed in full or in part, this disclaimer
#  may not apply to You.
#  
#  To the extent possible, in no event will the Licensor be liable to You on any
#  legal theory (including, without limitation, negligence) or otherwise for any
#  direct, special, indirect, incidental, consequential, punitive, exemplary, or
#  other losses, costs, expenses, or damages arising out of this Public License or
#  use of the Licensed Material, even if the Licensor has been advised of the
#  possibility of such losses, costs, expenses, or damages. Where a limitation of
#  liability is not allowed in full or in part, this limitation may not apply to You.
#
################################################## END OF LICENSE ##################################################

hu.hfstol:	casenormhu.hfstol huXlgNoSt.hfstol
	cat casenormhu.hfstol huXlgNoSt.hfstol >hu.hfstol

casenormhu.hfstol:	casenormhu.hfst
	hfst-fst2fst -O -o casenormhu.hfstol casenormhu.hfst

huXlgNoSt.hfstol:	huXlgNoSt.hfst
	hfst-fst2fst -O -o huXlgNoSt.hfstol huXlgNoSt.hfst

hu.hfst:	casenormhu.hfst huXlgNoSt.hfst
	cat casenormhu.hfst huXlgNoSt.hfst >hu.hfst

casenormhu.hfst:	casenormhuX.xfs
	echo "" | hfst-xfst -F casenormhuX.xfs

huXlgNoSt.hfst:	huXlg.hfst
	echo "" | hfst-xfst -e "load huXlg.hfst" -e "eliminate flag St" -e "ss huXlgNoSt.hfst" -e "exit"

huXlg.hfst:	huXlg.lexc
	echo "" | hfst-xfst -e "read lexc huXlg.lexc" -e "invert" -e "ss huXlg.hfst" -e "exit"

