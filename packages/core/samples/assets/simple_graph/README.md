# Simple Graph Sample

This directory contains a simple graph structure dataset used as a sample for the App application.

## Data Structure

This dataset consists of the following 4 files:

- `manifest.json`: Manifest file compliant with the stack exchange format
- `schema.json`: Schema definition file for the dataset
- `nodes.json`: Data for all nodes (entities)
- `links.json`: Data for links that define relationships between nodes

## Dataset Features

This sample is designed with a simple structure that does not include list-type properties:

### Node Composition
- **Person**: 3 employees (Alice, Bob, Charlie)
- **Company**: 1 company (TechCorp Inc.)
- **Project**: 1 project (Web Application Project)

### Link Composition
- **WORKS_FOR**: Employment relationship between employees and company
- **MANAGES**: Management relationship between project manager and project
- **ASSIGNED_TO**: Assignment relationship between developers and project
- **COLLABORATES_WITH**: Collaboration relationship between employees
- **OWNS**: Ownership relationship between company and project

## Use Cases

This sample is suitable for the following purposes:

- Testing basic functionality of the App application
- Learning basic operations of graph databases
- Verifying operation with simple data structures
- Basic test data for new feature development

## Data Characteristics

- **Simplicity**: Avoids complex list-type properties, using only basic string and numeric properties
- **Ease of Understanding**: Mimics a typical corporate organization structure
- **Extensibility**: Easy to add additional nodes and links as needed
