<%@ page import="org.quartz.Trigger" %>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=UTF-8" />
        <g:set var="layoutName" value="${grailsApplication.config.quartz?.monitor?.layout}" />
        <meta name="layout" content="${layoutName ?: 'main'}" />
        <title>Quartz Jobs</title>
        <asset:stylesheet href="quartz-monitor" />
        <asset:javascript src="quartz-monitor" />
    </head>
    <body>
        <div class="nav">
            <span class="menuButton">
                <g:link uri="/">
                    <g:message code="default.home.label"/>
                </g:link>
            </span>
        </div>
        <div class="body">
            <h1 id="quartz-title">
                Quartz Jobs
                <g:if test="${scheduler.inStandbyMode}">
                    <g:link action="startScheduler">
                        <asset:image class="quartz-tooltip" data-tooltip="Start scheduler" src="play-all.png" />
                    </g:link>
                </g:if>
                <g:else>
                    <g:link action="stopScheduler">
                        <asset:image class="quartz-tooltip" data-tooltip="Pause scheduler" src="pause-all.png" />
                    </g:link>
                </g:else>
            </h1>
            <g:if test="${flash.message}">
            <div class="message">${flash.message}</div>
            </g:if>
            <div id="clock" data-time="${now.time}">
                <h3>Current Time: ${now}</h3>
            </div>
            <div class="list">
                <table id="quartz-jobs">
                    <thead>
                        <tr>
                            <th>Name</th>
                            <g:if test="${grailsApplication.config.quartz.monitor.showTriggerNames}">
                                <th>Trigger Name</th>
                            </g:if>
                            <th>Last Run</th>
                            <th class="quartz-to-hide">Result</th>
                            <th>Next Scheduled Run</th>
                            <th>Actions</th>
                        </tr>
                    </thead>
                    <tbody>
                    <g:each in="${jobs}" status="i" var="job">
                        <tr class="${(i % 2) == 0 ? 'odd' : 'even'}">
                            <td>${job.name}</td>
                            <g:if test="${grailsApplication.config.quartz.monitor.showTriggerNames}">
                                <td>${job.trigger?.name}</td>
                            </g:if>
                            <g:set var="tooltip">${job.duration >= 0 ? "Job ran in: " + job.duration + "ms" : (job.error ? "Job threw exception: " + job.error : "")}</g:set>
                            <td class="quartz-tooltip quartz-status ${job.status?:"not-run"}" data-tooltip="${tooltip}">${job.lastRun}</td>
                            <td class="quartz-to-hide">${tooltip}</td>
                            <g:if test="${scheduler.isInStandbyMode() || job.triggerStatus == Trigger.TriggerState.PAUSED}">
                                <td class="hasCountdown countdown_amount">Paused</td>
                            </g:if>
                            <g:else>
                                <td class="quartz-countdown" data-next-run="${job.trigger?.nextFireTime?.time ?: ""}">${job.trigger?.nextFireTime}</td>
                            </g:else>
                            <td class="quartz-actions">
                                <g:if test="${job.status != 'running'}">
                                    <g:if test="${job.trigger}">
                                        <g:link action="stop" params="${[jobName: job.name, triggerName: job.trigger.name, triggerGroup: job.trigger.group]}">
                                            <asset:image class="quartz-tooltip" data-tooltip="Stop job from running again" src="stop.png" />
                                        </g:link>
                                        <g:if test="${job.triggerStatus == Trigger.TriggerState.PAUSED}">
                                            <g:link action="resume" params="${[jobName: job.name, jobGroup: job.group]}">
                                                <asset:image class="quartz-tooltip" data-tooltip="Resume job schedule" src="resume.png" />
                                            </g:link>
                                        </g:if>
                                        <g:elseif test="${job.trigger.mayFireAgain()}">
                                            <g:link action="pause" params="${[jobName: job.name, jobGroup: job.group]}">
                                                <asset:image class="quartz-tooltip" data-tooltip="Pause job schedule" src="pause.png" />
                                            </g:link>
                                        </g:elseif>
                                    </g:if>
                                    <g:else>
                                        <g:link action="start" params="${[jobName: job.name, jobGroup: job.group]}">
                                            <asset:image class="quartz-tooltip" data-tooltip="Start job schedule" src="start.png" />
                                        </g:link>
                                    </g:else>
                                    <g:link action="runNow" params="${[jobName: job.name, jobGroup: job.group]}">
                                        <asset:image class="quartz-tooltip" data-tooltip="Run now" src="run.png" />
                                    </g:link>
                                    <g:if test="${job.trigger instanceof org.quartz.CronTrigger}">
                                        <g:link action="editCronTrigger" params="${[triggerName: job.trigger.name, triggerGroup: job.trigger.group]}">
                                            <asset:image class="quartz-tooltip" data-tooltip="Reschedule" src="reschedule.png" />
                                        </g:link>
                                    </g:if>
                                </g:if>
                            </td>
                        </tr>
                    </g:each>
                    </tbody>
                </table>
            </div>
        </div>
    </body>
</html>
