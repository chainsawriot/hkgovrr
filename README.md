# hkgovrr

R Wrappers to Hong Kong Government APIs

## Installation

Install from github

```{r}
devtools::install_github(repo="hkgovrr", username ="chainsawriot", ref="master")
```

## Usage

Query the OGCIO to parse English free text Hong Kong Address

```{r}
queryogcio("66 Causeway Road, Causeway Bay, Hong Kong")
```

Can query Chinese address also!

```{r}
queryogcio("德輔道西1號")
```
