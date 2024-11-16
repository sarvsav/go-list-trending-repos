# go-list-trending-repos

Download and prints the github trending repos with `Go` language based on daily, weekly, and monthly intervals.

## A detailed description of what the action does

This action is written in Go and for learning purpose. It fetches the trending repositories on GitHub with `Go` language based on daily, weekly, and monthly intervals. The action uses the download the trending repositories HTML page and parses the data to get the trending repositories. The action returns the trending repositories in JSON format.

## Required input and output arguments

There is no required input argument for this action. The default value for the input argument `since` is `daily`.

## Optional input and output arguments

- `since`: The time interval for which the trending repositories are to be fetched. The possible values are `daily`, `weekly`, and `monthly`. The default value is `daily`.
- `version`: The version of the action.
- `json_data`: The output of the action.

## Secrets the action uses

There are no secrets used in this action.

## Environment variables the action uses

There is no environment variable used in this action.

## Sample Report

The output of this action is available through variable named `json_data`.

```json
{"data":{"daily":["Project-HAMi/HAMi","avelino/awesome-go","milvus-io/milvus","aquasecurity/trivy","argoproj/argo-rollouts","tailscale/tailscale","VictoriaMetrics/VictoriaMetrics","jesseduffield/lazydocker","containers/skopeo","anchore/grype","nxtrace/NTrace-core","weaviate/weaviate","coder/coder","vmware-tanzu/velero","encoredev/encore","bluenviron/mediamtx","dagger/dagger","sigstore/cosign","DiceDB/dice","jaegertracing/jaeger","dapr/dapr","junegunn/fzf","juanfont/headscale","binwiederhier/ntfy","nektos/act"],"weekly":["AlexxIT/go2rtc","aquasecurity/trivy","juanfont/headscale","IceWhaleTech/CasaOS","weaviate/weaviate","dapr/dapr","gitleaks/gitleaks","jesseduffield/lazydocker","pocketbase/pocketbase","vmware-tanzu/velero","GoogleCloudPlatform/microservices-demo","VictoriaMetrics/VictoriaMetrics","juicedata/juicefs","schollz/croc","containerd/containerd","derailed/k9s","lima-vm/lima","anchore/grype","milvus-io/milvus","bufbuild/buf","containers/skopeo","amir20/dozzle","cli/cli","coder/coder","anchore/syft"],"monthly":["aquasecurity/trivy","avelino/awesome-go","usememos/memos","AlexxIT/go2rtc","trufflesecurity/trufflehog","junegunn/fzf","milvus-io/milvus","pocketbase/pocketbase","sundowndev/phoneinfoga","weaviate/weaviate","dapr/dapr","NVIDIA/k8s-device-plugin","containerd/nerdctl","TwiN/gatus","ThreeDotsLabs/watermill","anchore/syft","vmware-tanzu/velero","juicedata/juicefs","k3s-io/k3s","authelia/authelia","VictoriaMetrics/VictoriaMetrics","terrastruct/d2","lima-vm/lima","evcc-io/evcc","jesseduffield/lazydocker"]}}
```

## An example of how to use your action in a workflow

Create a workflow file in your repository `.github/workflows/go-list-trending-repos.yml` with the following content:

```yaml
name: List trending Go repositories

## Add triggers on pushing to main or manually running the workflow
on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  go_list_trending_repos:
    runs-on: ubuntu-latest
    name: A job to list the trending golang repositories on GitHub
    steps:
      - name: Check out the repo
        uses: actions/checkout@v4
      - name: List version information
        id: version
        uses: sarvsav/go-list-trending-repos@main
        with:
            version: -v
      - name: Generate daily report
        id: daily
        uses: sarvsav/go-list-trending-repos@main
        with:
            since: daily
      - name: Show results
        id: print
        run: |
          echo "Step outputs: ${{ steps.daily.outputs.json_data }}"
```

## Example use cases

- As a maintainer, I want to see the trending Go repositories on GitHub so that I can keep track of the latest trends in the Go community.

## License

This project is licensed under the MIT License - see the [LICENSE](./LICENSE) file for details.

## Versioning

Inspired from the project: [usnistgov/ndn-dpdk](https://github.com/usnistgov/ndn-dpdk/blob/4d2d7ccc1ec74e99a23515fc96a46db316fdcb59/mk/version/version.go)

## Contributions

We would ❤️ contributions to improve this action. Please see [CONTRIBUTING.md](CONTRIBUTING.md) for how to get involved.

## References

- [How to create a GitHub Action using Docker](https://docs.github.com/en/actions/sharing-automations/creating-actions/creating-a-docker-container-action)
