---
menu_title: Hosting
title: Tools - Hosting
permalink: /notes/tools/hosting/
---

<h4>Table of Contents</h4>
* TOC
{:toc}

* [AWS](https://aws.amazon.com/)
  * Pricing: [https://aws.amazon.com/pricing/?nc2=h_ql_pr](https://aws.amazon.com/pricing/?nc2=h_ql_pr)
  * Free-Tier: [https://aws.amazon.com/free/?nc2=h_ql_pr](https://aws.amazon.com/free/?nc2=h_ql_pr)
* [Google Cloud Platform](https://cloud.google.com/)
  * Pricing: [https://cloud.google.com/pricing/](https://cloud.google.com/pricing/)
  * Free-Tier: [https://cloud.google.com/free/](https://cloud.google.com/free/)
* [Microsoft Azure](https://azure.microsoft.com/en-us/)
  * Pricing: [https://azure.microsoft.com/en-us/pricing/](https://azure.microsoft.com/en-us/pricing/)
  * Free-Tier: [https://azure.microsoft.com/en-us/free/](https://azure.microsoft.com/en-us/free/)
* [DigitalOcean](https://www.digitalocean.com/)
  * Pricing: [https://www.digitalocean.com/pricing/](https://www.digitalocean.com/pricing/)
  * Free-Tier: []()
* [Heroku](https://www.heroku.com/home)
  * Pricing: [https://www.heroku.com/pricing](https://www.heroku.com/pricing)
  * Free-Tier: []()

### Google Cloud Platform (GCP)

#### Show Active Project

```bash
$ gcloud config get-value project
```

<span class="info-source">Source: <https://stackoverflow.com/questions/63041888/how-to-check-which-gcloud-project-is-active></span>

#### List Resources

```bash
$ gcloud beta asset search-all-resources  --scope='projects/project123'
```

<span class="info-source">Source:</span>
* <span class="info-source"><https://stackoverflow.com/questions/58102443/using-gcloud-to-list-all-active-resources-under-a-given-gcp-project></span>
* <span class="info-source"><https://cloud.google.com/sdk/gcloud/reference/beta/asset/search-all-resources></span>

