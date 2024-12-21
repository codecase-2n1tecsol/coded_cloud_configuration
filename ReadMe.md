# coded_cloud_configuration

This is the infancy or incubator from which the "Orchestrator" will be born from. It houses the code and templates to configure key components of the 365 landscape.

#### Special Note

Sensitve files (those with information that must be protected at all cost) have deplicate objects. What you see here on Github (or whereever you are seeing this) is not the entirety
of the actually local dev/production code base/exe program. Basically, any file that contains generic field value info like "[your info]", will have a duplicate file prepended with '.' for gitigrnore purposes. When using this code, you will need to make adjustments somewhere to accomidate for this. Where or how is up to you. The easist option would be to create the missing (duplicate) files with the '.' prepended.

## Stages

There are several items to attend to before any core operations are performed. The first segmented step or Stage of this program/project is called setup\_\* or phase_setup. You will want to visit any and every code file, directory, etc that has "setup" as part of its name. In the future, this will be less needed. We will create a single script that will call/run all the other scripts and operations needed for that step/phase.

### Stage 1 "Setep Phase"

Creating the (local) dev environment, cloning the repo, adjusting code files, creating cloud (Azure/Entra) resources (setup_cloud/phase_setup), parsing/formating/hydrating/label/securing data and ensuring reusability of data.

#### as of this commit/branch/time we are preparing to target two areas (Conditional Access Policies & Intune Polcies).
