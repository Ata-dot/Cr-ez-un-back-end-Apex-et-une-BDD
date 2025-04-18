# GlobalGroupTravel-Cr-ez-un-back-end-Apex-et-une-BDD

Ce projet a pour objectif de mettre en place un système CRM sur Salesforce pour la gestion des voyages de groupe pour les entreprises et organisations.

## Structure du projet

- `force-app-default/` : Code source pour Apex, LWC, objets personnalisés, et déclencheurs.
- `tests/` : Tests unitaires pour chaque partie du code.
- `documentation/` : Documentation de l'architecture et des fonctionnalités.
- `configuration/` : Configuration de l'architecture et des fonctionnalités.

## Convention de nommage

- Nommage des classes Apex : Nom clair et descriptif, utilisation du PascalCase, suffixer en fonction du type (Controller, Service, TriggerHandler, Helper). Exemple : AccountManager.
- Nommage des Trigger :  Nom avec le nom de l'objet suivi du mot Trigger. Exemple : CreateTriponOpportunitywin.trigger.
- Nommage des méthodes et variables : Nommer les variables de manière descriptive, utilisation du CamelCase. Exemple : totalParticipants.

=======
# Salesforce DX Project: Next Steps

Now that you’ve created a Salesforce DX project, what’s next? Here are some documentation resources to get you started.

## How Do You Plan to Deploy Your Changes?

Do you want to deploy a set of changes, or create a self-contained application? Choose a [development model](https://developer.salesforce.com/tools/vscode/en/user-guide/development-models).

## Configure Your Salesforce DX Project

The `sfdx-project.json` file contains useful configuration information for your project. See [Salesforce DX Project Configuration](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_ws_config.htm) in the _Salesforce DX Developer Guide_ for details about this file.

## Read All About It

- [Salesforce Extensions Documentation](https://developer.salesforce.com/tools/vscode/)
- [Salesforce CLI Setup Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_setup.meta/sfdx_setup/sfdx_setup_intro.htm)
- [Salesforce DX Developer Guide](https://developer.salesforce.com/docs/atlas.en-us.sfdx_dev.meta/sfdx_dev/sfdx_dev_intro.htm)
- [Salesforce CLI Command Reference](https://developer.salesforce.com/docs/atlas.en-us.sfdx_cli_reference.meta/sfdx_cli_reference/cli_reference.htm)
