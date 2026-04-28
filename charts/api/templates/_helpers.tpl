{{/*
Expand the name of the chart.
*/}}
{{- define "api.names.name" -}}
{{- include "common.names.name" . -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "api.names.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end -}}

{{/*
Allow the release namespace to be overridden.
*/}}
{{- define "api.names.namespace" -}}
{{- include "common.names.namespace" . -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "api.names.chart" -}}
{{- include "common.names.chart" . -}}
{{- end -}}

{{/*
Kubernetes standard labels.
*/}}
{{- define "api.labels.standard" -}}
{{- include "common.labels.standard" . -}}
{{- end -}}

{{/*
Labels used on selector.matchLabels and Service spec.selector.
*/}}
{{- define "api.labels.matchLabels" -}}
{{- include "common.labels.matchLabels" . -}}
{{- end -}}

{{/*
Return the proper image name.
Usage: {{ include "api.image" . }}
*/}}
{{- define "api.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) -}}
{{- end -}}

{{/*
Return the ServiceAccount name to use.
Usage: {{ include "api.serviceAccountName" . }}
*/}}
{{- define "api.serviceAccountName" -}}
{{- include "common.rbac.serviceAccountName" (dict "serviceAccount" .Values.serviceAccount "context" $) -}}
{{- end -}}
