{{/*
Expand the name of the chart.
*/}}
{{- define "checkmk.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "checkmk.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "checkmk.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "checkmk.labels" -}}
helm.sh/chart: {{ include "checkmk.chart" . }}
{{ include "checkmk.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "checkmk.selectorLabels" -}}
app.kubernetes.io/name: {{ include "checkmk.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service accounts
*/}}
{{- define "checkmk.serviceAccountName.checkmk" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (print (include "checkmk.fullname" .) "-checkmk") .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{- define "checkmk.serviceAccountName.clusterCollector" -}}
    {{ print (include "checkmk.fullname" .) "-cluster-collector" }}
{{- end -}}

{{- define "checkmk.serviceAccountName.nodeCollector.containerMetricsCollector" -}}
    {{ print (include "checkmk.fullname" .) "-node-collector-container-metrics" }}
{{- end -}}

{{- define "checkmk.serviceAccountName.nodeCollector.machineSectionsCollector" -}}
    {{ print (include "checkmk.fullname" .) "-node-collector-machine-sections" }}
{{- end -}}

{{/*
Allow KubeVersion to be overridden
*/}}
{{- define "checkmk.kubeVersion" -}}
    {{- default .Capabilities.KubeVersion.Version .Values.kubeVersionOverride -}}
{{- end -}}
