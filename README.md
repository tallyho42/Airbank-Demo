# Airbank-Demo

Vytvoreno v Xcode 7.1 (7B91b)

Repository obsahuje projekt ve Swiftu + slozku s grafikou (kvuli memu puvodnimu planu udelat demo jak ve Swiftu tak v Objective-C). Rozhodnutí jestli použít Swift, nebo Objective-C bylo víceméně náhodné. V reálném projektu by nicméně rozhodně stálo za zvážení použití Objective-C.

Projekt obsahuje CocoaPods skrze ktere je integrovano nekolik frameworku - Alamofire, Async, SnapKit. V pripade ostreho projektu by stalo za zvazeni nahrazeni Alamofire nativnim NSURLSession, to by nicmene v pripade dema trvalo zbytecne dlouho. Vymena Alamofire by byla jednoducha, jelikoz ho app pouziva pouze na 1 radku. Ostatni frameworky jsou jednoduche na pochopeni a pridane s ohledem na predani kodu a dlouhodoby rozvoj.

Projekt je koncipovan ve smyslu Model-View-Controller a s cilem co mozna nejjednodussiho dalsiho rozsireni. Do modelu je mozne pridavat nove API calls pouhym pridani noveho case do enum "ApiMethodDefaults" a definovanim prislusneho parseru.