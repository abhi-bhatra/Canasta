{{/*
Expand the name of the chart.
*/}}
{{- define "canasta-helm.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "canasta-helm.fullname" -}}
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
{{- define "canasta-helm.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "canasta-helm.labels" -}}
helm.sh/chart: {{ include "canasta-helm.chart" . }}
{{ include "canasta-helm.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "canasta-helm.selectorLabels" -}}
app.kubernetes.io/name: {{ include "canasta-helm.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "canasta-helm.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "canasta-helm.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper Canasta DB image name
*/}}
{{- define "canasta.image" -}}
{{ printf "%s" .Values.db.db.image.repository }}:{{ printf "%s" .Values.db.db.image.tag }}
{{- end -}}

{{/*
Return the MySQL Database Name
*/}}
{{- define "canasta.databaseName" -}}
{{- printf "%s" .Values.externalDatabase.database -}}
{{- end -}}

{{/*
Return the Canasta MySQL Secret Name
*/}}
{{- define "canasta.databaseSecretName" -}}
{{- printf "%s-externaldb" (include "common.names.fullname" .) -}}
{{- end -}}
