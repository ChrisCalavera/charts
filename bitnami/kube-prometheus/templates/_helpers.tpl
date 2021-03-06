{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "kube-prometheus.name" -}}
{{- include "common.names.name" . -}}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "kube-prometheus.fullname" -}}
{{- include "common.names.fullname" . -}}
{{- end }}

{{/* Name suffixed with operator */}}
{{- define "kube-prometheus.operator.name" -}}
{{- printf "%s-operator" (include "kube-prometheus.name" .) -}}
{{- end }}

{{/* Name suffixed with prometheus */}}
{{- define "kube-prometheus.prometheus.name" -}}
{{- printf "%s-prometheus" (include "kube-prometheus.name" .) -}}
{{- end }}

{{/* Name suffixed with alertmanager */}}
{{- define "kube-prometheus.alertmanager.name" -}}
{{- printf "%s-alertmanager" (include "kube-prometheus.name" .) -}}
{{- end }}

{{/* Fullname suffixed with operator */}}
{{- define "kube-prometheus.operator.fullname" -}}
{{- printf "%s-operator" (include "kube-prometheus.fullname" .) -}}
{{- end }}

{{/* Fullname suffixed with prometheus */}}
{{- define "kube-prometheus.prometheus.fullname" -}}
{{- printf "%s-prometheus" (include "kube-prometheus.fullname" .) -}}
{{- end }}

{{/* Fullname suffixed with alertmanager */}}
{{- define "kube-prometheus.alertmanager.fullname" -}}
{{- printf "%s-alertmanager" (include "kube-prometheus.fullname" .) -}}
{{- end }}

{{- define "kube-prometheus.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Labels for operator
*/}}
{{- define "kube-prometheus.operator.labels" -}}
{{ include "common.labels.standard" . }}
app.kubernetes.io/component: operator
{{- end -}}

{{/*
Labels for prometheus
*/}}
{{- define "kube-prometheus.prometheus.labels" -}}
{{ include "common.labels.standard" . }}
app.kubernetes.io/component: prometheus
{{- end -}}

{{/*
Labels for alertmanager
*/}}
{{- define "kube-prometheus.alertmanager.labels" -}}
{{ include "common.labels.standard" . }}
app.kubernetes.io/component: alertmanager
{{- end -}}

{{/*
matchLabels for operator
*/}}
{{- define "kube-prometheus.operator.matchLabels" -}}
{{ include "common.labels.matchLabels" . }}
app.kubernetes.io/component: operator
{{- end -}}

{{/*
matchLabels for prometheus
*/}}
{{- define "kube-prometheus.prometheus.matchLabels" -}}
{{ include "common.labels.matchLabels" . }}
app.kubernetes.io/component: prometheus
{{- end -}}

{{/*
matchLabels for alertmanager
*/}}
{{- define "kube-prometheus.alertmanager.matchLabels" -}}
{{ include "common.labels.matchLabels" . }}
app.kubernetes.io/component: alertmanager
{{- end -}}

{{/*
Return the proper Prometheus Operator image name
*/}}
{{- define "kube-prometheus.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.operator.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Prometheus Operator Reloader image name
*/}}
{{- define "kube-prometheus.prometheusConfigReloader.image" -}}
{{- if and .Values.operator.prometheusConfigReloader.image.registry (and .Values.operator.prometheusConfigReloader.image.repository .Values.operator.prometheusConfigReloader.image.tag) }}
{{- include "common.images.image" (dict "imageRoot" .Values.operator.prometheusConfigReloader.image "global" .Values.global) }}
{{- else -}}
{{- include "kube-prometheus.image" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper ConfigMap Reload image name
*/}}
{{- define "kube-prometheus.configmapReload.image" -}}
{{- if and .Values.operator.configmapReload.image.registry (and .Values.operator.configmapReload.image.repository .Values.operator.configmapReload.image.tag) }}
{{- include "common.images.image" (dict "imageRoot" .Values.operator.configmapReload.image "global" .Values.global) }}
{{- else -}}
{{- include "kube-prometheus.image" . -}}
{{- end -}}
{{- end -}}

{{/*
Return the proper Prometheus Image name
*/}}
{{- define "kube-prometheus.prometheus.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.prometheus.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Thanos Image name
*/}}
{{- define "kube-prometheus.prometheus.thanosImage" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.prometheus.thanos.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Alertmanager Image name
*/}}
{{- define "kube-prometheus.alertmanager.image" -}}
{{- include "common.images.image" (dict "imageRoot" .Values.alertmanager.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "kube-prometheus.imagePullSecrets" -}}
{{ include "common.images.pullSecrets" (dict "images" (list .Values.operator.image .Values.operator.prometheusConfigReloader.image .Values.operator.configmapReload.image .Values.prometheus.image .Values.prometheus.thanos.image .Values.alertmanager.image) "global" .Values.global) }}
{{- end -}}

{{/*
Create the name of the operator service account to use
*/}}
{{- define "kube-prometheus.operator.serviceAccountName" -}}
{{- if .Values.operator.serviceAccount.create -}}
    {{ default (include "kube-prometheus.operator.fullname" .) .Values.operator.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.operator.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the prometheus service account to use
*/}}
{{- define "kube-prometheus.prometheus.serviceAccountName" -}}
{{- if .Values.prometheus.serviceAccount.create -}}
    {{ default (include "kube-prometheus.prometheus.fullname" .) .Values.prometheus.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.prometheus.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Create the name of the alertmanager service account to use
*/}}
{{- define "kube-prometheus.alertmanager.serviceAccountName" -}}
{{- if .Values.alertmanager.serviceAccount.create -}}
    {{ default (include "kube-prometheus.alertmanager.fullname" .) .Values.alertmanager.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.alertmanager.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Return the appropriate apiVersion for PodSecurityPolicy.
*/}}
{{- define "podSecurityPolicy.apiVersion" -}}
{{- if semverCompare ">=1.14-0" .Capabilities.KubeVersion.GitVersion -}}
{{- print "policy/v1beta1" -}}
{{- else -}}
{{- print "extensions/v1beta1" -}}
{{- end -}}
{{- end -}}

{{/*
Compile all warnings into a single message, and call fail.
*/}}
{{- define "kube-prometheus.validateValues" -}}
{{- $messages := list -}}
{{- $messages := without $messages "" -}}
{{- $message := join "\n" $messages -}}

{{- if $message -}}
{{- printf "\nVALUES VALIDATION:\n%s" $message | fail -}}
{{- end -}}
{{- end -}}
