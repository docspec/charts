{{/*
Return the proper image name.
Usage:
{{ include "common.images.image" (dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "common.images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := .imageRoot.tag | toString -}}
{{- if .global }}
    {{- if .global.imageRegistry }}
     {{- $registryName = .global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}
{{- if $registryName }}
    {{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- else -}}
    {{- printf "%s%s%s" $repositoryName $separator $termination -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names evaluating values as templates.
Usage:
{{ include "common.images.renderPullSecrets" (dict "images" (list .Values.path.to.the.image1, .Values.path.to.the.image2) "context" $) }}
*/}}
{{- define "common.images.renderPullSecrets" -}}
  {{- $pullSecrets := list -}}
  {{- $context := .context -}}

  {{- if $context.Values.global -}}
    {{- range $context.Values.global.imagePullSecrets -}}
      {{- $pullSecrets = append $pullSecrets (include "common.tplvalues.render" (dict "value" . "context" $context)) -}}
    {{- end -}}
  {{- end -}}
  {{- range .images -}}
    {{- range .pullSecrets -}}
      {{- $pullSecrets = append $pullSecrets (include "common.tplvalues.render" (dict "value" . "context" $context)) -}}
    {{- end -}}
  {{- end -}}
  {{- if (not (empty $pullSecrets)) -}}
imagePullSecrets:
    {{- range (uniq $pullSecrets) }}
  - name: {{ . }}
    {{- end }}
  {{- end }}
{{- end -}}

{{/*
Return the list of image pull secrets (as a list, not rendered YAML).
Usage:
{{ include "common.images.pullSecrets" (dict "images" (list .Values.path.to.the.image1) "global" .Values.global) }}
*/}}
{{- define "common.images.pullSecrets" -}}
  {{- $pullSecrets := list -}}
  {{- if .global -}}
    {{- range .global.imagePullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}
  {{- range .images -}}
    {{- range .pullSecrets -}}
      {{- $pullSecrets = append $pullSecrets . -}}
    {{- end -}}
  {{- end -}}
  {{- if (not (empty $pullSecrets)) -}}
    {{- uniq $pullSecrets | toJson -}}
  {{- end -}}
{{- end -}}

{{/*
Return the proper image version (tag or digest).
Usage:
{{ include "common.images.version" (dict "imageRoot" .Values.path.to.the.image "chart" .Chart) }}
*/}}
{{- define "common.images.version" -}}
{{- if .imageRoot.digest -}}
    {{- .imageRoot.digest -}}
{{- else if .imageRoot.tag -}}
    {{- .imageRoot.tag | toString -}}
{{- else -}}
    {{- .chart.AppVersion -}}
{{- end -}}
{{- end -}}
