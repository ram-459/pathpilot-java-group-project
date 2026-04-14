<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core" %>

        <% response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate" );
            response.setHeader("Pragma", "no-cache" ); response.setDateHeader("Expires", 0); if(session==null ||
            session.getAttribute("role")==null){ response.sendRedirect(request.getContextPath() + "/login" ); return; }
            %>

            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>
                    <c:choose>
                        <c:when test="${viewMode == 'quiz'}">${title} Assessment</c:when>
                        <c:otherwise>Select Assessment - PathPilot</c:otherwise>
                    </c:choose>
                </title>
                <script src="https://cdn.tailwindcss.com"></script>
                <script src="https://cdn.jsdelivr.net/npm/sweetalert2@11"></script>
                <link
                    href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@400;500;600;700;800&display=swap"
                    rel="stylesheet" />
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0/css/all.min.css">

                <style>
                    body {
                        font-family: 'Plus Jakarta Sans', sans-serif;
                        background-color: #f8f9fc;
                        min-height: 100vh;
                    }

                    input[type="radio"] {
                        appearance: none;
                        -webkit-appearance: none;
                        width: 22px;
                        height: 22px;
                        border: 2px solid #e2e8f0;
                        border-radius: 6px;
                        background: white;
                        cursor: pointer;
                        position: relative;
                        outline: none;
                        flex-shrink: 0;
                        transition: all 0.2s ease;
                    }

                    input[type="radio"]:checked {
                        border-color: #4913ec;
                        background-color: #f5f3ff;
                    }

                    input[type="radio"]:checked::after {
                        content: '\f00c';
                        font-family: 'Font Awesome 5 Free';
                        font-weight: 900;
                        font-size: 11px;
                        color: #4913ec;
                        position: absolute;
                        top: 50%;
                        left: 50%;
                        transform: translate(-50%, -50%);
                    }

                    .option-container {
                        @apply flex items-center gap-4 py-4 px-6 rounded-2xl border-2 border-transparent hover:bg-white hover:shadow-md transition-all duration-200 cursor-pointer;
                    }

                    .option-container:hover input[type="radio"] {
                        border-color: #4913ec;
                    }

                    .progress-bar-container {
                        @apply w-full bg-gray-200 h-1.5 rounded-full overflow-hidden;
                    }

                    .phase-card {
                        @apply bg-white rounded-2xl border border-gray-100 p-6 shadow-sm hover:shadow-md hover:border-primary/30 transition-all duration-300 cursor-pointer;
                    }

                    .phase-card:hover {
                        transform: translateY(-2px);
                    }
                </style>
            </head>

            <body class="antialiased flex flex-col">

                <!-- PHASE SELECTION VIEW -->
                <c:if test="${viewMode == 'select'}">
                    <nav
                        class="bg-white border-b border-gray-100 py-5 px-10 flex justify-between items-center shadow-sm">
                        <div class="flex items-center gap-4">
                            <div
                                class="w-10 h-10 rounded-xl bg-[#4913ec] flex items-center justify-center text-white shadow-lg shadow-indigo-200">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <div>
                                <h1 class="text-lg font-800 text-gray-900 tracking-tight">Assessment Selection</h1>
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">
                                    ${careerPath.title}</p>
                            </div>
                        </div>

                        <a href="<%=request.getContextPath()%>/student/course-details/${pathId}"
                            class="text-gray-400 hover:text-red-500 transition-colors">
                            <i class="fas fa-times-circle text-xl"></i>
                        </a>
                    </nav>

                    <main class="flex-grow flex items-center justify-center px-6 py-12">
                        <div class="max-w-4xl w-full">

                            <div class="mb-12">
                                <span
                                    class="inline-block px-4 py-1.5 rounded-full bg-indigo-50 text-[#4913ec] text-[10px] font-black uppercase tracking-widest mb-4">Select
                                    Phase</span>
                                <h2 class="text-3xl font-800 text-gray-900 leading-tight tracking-tight">
                                    ${careerPath.title}
                                </h2>
                                <p class="text-gray-500 mt-3 font-medium">Choose a phase to take its assessment quiz</p>
                            </div>

                            <c:choose>
                                <c:when test="${not empty phases}">
                                    <div class="grid md:grid-cols-2 gap-6">
                                        <c:forEach var="phase" items="${phases}" varStatus="phaseLoop">
                                            <div onclick="startQuiz(${phase.phaseId})" class="phase-card">
                                                <div class="flex items-start justify-between mb-4">
                                                    <div
                                                        class="w-12 h-12 rounded-xl bg-[#4913ec] flex items-center justify-center text-white font-bold text-lg">
                                                        ${phase.phaseNumber}
                                                    </div>
                                                    <span
                                                        class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Phase
                                                        ${phase.phaseNumber}</span>
                                                </div>

                                                <h3 class="text-xl font-800 text-gray-900 mb-2">${phase.title}</h3>
                                                <p class="text-gray-500 text-sm mb-4">${phase.content}</p>

                                                <div
                                                    class="flex items-center justify-between pt-4 border-t border-gray-100">
                                                    <span class="text-[10px] font-bold text-green-600 uppercase">5
                                                        Questions</span>
                                                    <span
                                                        class="text-primary font-bold hover:underline flex items-center gap-1">
                                                        Start Quiz <i class="fas fa-arrow-right text-xs"></i>
                                                    </span>
                                                </div>
                                            </div>
                                        </c:forEach>
                                    </div>
                                </c:when>
                                <c:otherwise>
                                    <div class="text-center py-20">
                                        <i class="fas fa-exclamation-circle text-5xl text-gray-300 mb-4"></i>
                                        <h3 class="text-2xl font-bold text-gray-600 mb-2">No Phases Available</h3>
                                        <p class="text-gray-500 mb-6">This career path doesn't have any phases yet.</p>
                                        <a href="<%=request.getContextPath()%>/student/course-details/${pathId}"
                                            class="bg-[#4913ec] hover:bg-[#3a0fb5] text-white px-8 py-3 rounded-2xl font-bold transition-all inline-block">
                                            Back to Course
                                        </a>
                                    </div>
                                </c:otherwise>
                            </c:choose>
                        </div>
                    </main>

                    <script>
                        function startQuiz(phaseId) {
                            window.location.href = "<%=request.getContextPath()%>/student/quiz/" + phaseId;
                        }
                    </script>
                </c:if>

                <!-- QUIZ VIEW -->
                <c:if test="${viewMode == 'quiz'}">
                    <nav
                        class="bg-white border-b border-gray-100 py-5 px-10 flex justify-between items-center shadow-sm">
                        <div class="flex items-center gap-4">
                            <div
                                class="w-10 h-10 rounded-xl bg-[#4913ec] flex items-center justify-center text-white shadow-lg shadow-indigo-200">
                                <i class="fas fa-graduation-cap"></i>
                            </div>
                            <div>
                                <h1 class="text-lg font-800 text-gray-900 tracking-tight">${title} Assessment</h1>
                                <p class="text-[10px] font-black text-gray-400 uppercase tracking-widest">Phase
                                    ${phaseId}</p>
                            </div>
                        </div>

                        <div class="flex items-center gap-6">
                            <div class="text-right hidden sm:block">
                                <span id="qCountDisplay"
                                    class="text-[10px] font-black text-indigo-600 uppercase tracking-widest">Question 1
                                    of 1</span>
                                <div class="progress-bar-container mt-1 w-32">
                                    <div id="progressBar" class="bg-[#4913ec] h-full w-0 transition-all duration-700">
                                    </div>
                                </div>
                            </div>
                            <button onclick="history.back()" class="text-gray-400 hover:text-red-500 transition-colors">
                                <i class="fas fa-times-circle text-xl"></i>
                            </button>
                        </div>
                    </nav>

                    <main class="flex-grow flex items-center justify-center px-6 py-12">
                        <div id="quizBox" class="max-w-2xl w-full">

                            <c:if test="${empty questions}">
                                <div class="text-center py-12">
                                    <i class="fas fa-exclamation-circle text-5xl text-gray-300 mb-4"></i>
                                    <h2 class="text-2xl font-bold text-gray-600 mb-2">No Questions Available</h2>
                                    <p class="text-gray-500 mb-6">This phase doesn't have any assessment questions yet.
                                    </p>
                                    <button onclick="history.back()"
                                        class="bg-[#4913ec] hover:bg-[#3a0fb5] text-white px-8 py-3 rounded-2xl font-bold transition-all">
                                        Go Back
                                    </button>
                                </div>
                            </c:if>

                            <c:if test="${not empty questions}">
                                <div class="mb-12">
                                    <span
                                        class="inline-block px-4 py-1.5 rounded-full bg-indigo-50 text-[#4913ec] text-[10px] font-black uppercase tracking-widest mb-4">Knowledge
                                        Check</span>
                                    <h2 id="qText" class="text-3xl font-800 text-gray-900 leading-tight tracking-tight">
                                        Loading your question...
                                    </h2>
                                </div>

                                <div id="optionsBox" class="flex flex-col gap-2">
                                </div>

                                <div class="mt-16 pt-8 border-t border-gray-100 flex justify-between items-center">
                                    <button onclick="confirmExit()"
                                        class="text-gray-400 hover:text-gray-600 text-xs font-bold uppercase tracking-widest transition-all">
                                        Quit Assessment
                                    </button>

                                    <button id="nextBtn" onclick="submitAnswer()"
                                        class="bg-[#4913ec] hover:bg-[#3a0fb5] text-white px-12 py-4 rounded-2xl font-bold text-sm shadow-xl shadow-indigo-200 transition-all active:scale-95 flex items-center gap-3">
                                        Submit & Next <i class="fas fa-arrow-right text-[10px]"></i>
                                    </button>
                                </div>
                            </c:if>
                        </div>
                    </main>

                    <c:if test="${not empty questions}">
                        <script>
                            function letterToIndex(letter) {
                                const map = { 'A': 0, 'B': 1, 'C': 2, 'D': 3 };
                                return map[letter] !== undefined ? map[letter] : 0;
                            }

                            const questionsData = [
                                <c:forEach var="question" items="${questions}" varStatus="qStatus">
                                    {
                                        id: ${question.questionId},
                                    q: "${question.questionText}",
                                    o: [
                                    <c:forEach var="option" items="${question.options}" varStatus="oStatus">
                                        "${option.optionText}"<c:if test="${!oStatus.last}">,</c:if>
                                    </c:forEach>
                                    ],
                                    a: letterToIndex("${question.correctAnswer}")
                        }<c:if test="${!qStatus.last}">,</c:if>
                                </c:forEach>
                            ];

                            let currentIdx = 0;
                            let score = 0;
                            const totalQuestions = questionsData.length;
                            const activePhaseId = ${ phaseId };
                            const activeEnrollmentId = ${empty enrollmentId ? 0 : enrollmentId};
                            const ctx = "${pageContext.request.contextPath}";
                            let userResponses = []; // Track all responses

                            function loadQuestion() {
                                if (totalQuestions === 0) return;

                                const q = questionsData[currentIdx];

                                document.getElementById('qCountDisplay').innerText = "Question " + (currentIdx + 1) + " of " + totalQuestions;
                                document.getElementById('qText').innerText = q.q;
                                document.getElementById('progressBar').style.width = ((currentIdx) / totalQuestions * 100) + "%";

                                const optionsBox = document.getElementById('optionsBox');
                                let html = "";

                                q.o.forEach((opt, i) => {
                                    html += '<label class="option-container group">';
                                    html += '   <input type="radio" name="quizOpt" value="' + i + '" class="quiz-option">';
                                    html += '   <span class="text-xl font-medium text-gray-600 group-hover:text-gray-900 transition-colors">' + opt + '</span>';
                                    html += '</label>';
                                });

                                optionsBox.innerHTML = html;

                                // If user already answered this question, restore their selection
                                if (userResponses[currentIdx] !== undefined) {
                                    const savedOption = document.querySelector('input[value="' + userResponses[currentIdx] + '"]');
                                    if (savedOption) {
                                        savedOption.checked = true;
                                    }
                                }
                            }

                            function getSelectedAnswer() {
                                const selectedRadio = document.querySelector('input[name="quizOpt"]:checked');
                                return selectedRadio ? parseInt(selectedRadio.value) : -1;
                            }

                            function submitAnswer() {
                                const selectedOption = getSelectedAnswer();

                                // Save this response (-1 means unanswered/skip)
                                userResponses[currentIdx] = selectedOption;

                                currentIdx++;
                                if (currentIdx < totalQuestions) {
                                    loadQuestion();
                                } else {
                                    finishQuiz();
                                }
                            }

                            async function persistQuizResult() {
                                try {
                                    const localScore = questionsData.reduce((acc, question, index) => {
                                        return acc + (userResponses[index] === question.a ? 1 : 0);
                                    }, 0);

                                    const formattedResponses = questionsData.map((question, index) => ({
                                        questionId: question.id,
                                        selectedIndex: userResponses[index] !== undefined ? userResponses[index] : -1
                                    }));

                                    const response = await fetch("${pageContext.request.contextPath}/student/quiz/submit", {
                                        method: 'POST',
                                        headers: { 'Content-Type': 'application/json' },
                                        body: JSON.stringify({
                                            phaseId: activePhaseId,
                                            score: localScore,
                                            totalQuestions: totalQuestions,
                                            responses: formattedResponses
                                        })
                                    });
                                    if (!response.ok) {
                                        const rawText = await response.text().catch(() => '');
                                        let errorPayload = {};
                                        try {
                                            errorPayload = rawText ? JSON.parse(rawText) : {};
                                        } catch (e) {
                                            errorPayload = {};
                                        }
                                        return {
                                            error: errorPayload.error || 'SAVE_FAILED',
                                            message: errorPayload.message || rawText || '',
                                            status: response.status
                                        };
                                    }
                                    const successText = await response.text();
                                    return successText ? JSON.parse(successText) : {};
                                } catch (e) {
                                    console.error('Failed to persist quiz result', e);
                                    return { error: 'NETWORK_ERROR', message: e.message || '' };
                                }
                            }

                            async function finishQuiz() {
                                document.getElementById('progressBar').style.width = "100%";
                                const title = "${title}";
                                const resultData = await persistQuizResult();
                                if (resultData && resultData.error) {
                                    Swal.fire({
                                        title: 'Could not save quiz result',
                                        text: 'Please retry. Error: ' + resultData.error + (resultData.status ? (' (HTTP ' + resultData.status + ')') : '') + (resultData.message ? (' - ' + resultData.message) : ''),
                                        icon: 'error',
                                        confirmButtonColor: '#4913ec'
                                    });
                                    return;
                                }

                                const localScore = questionsData.reduce((acc, question, index) => {
                                    return acc + (userResponses[index] === question.a ? 1 : 0);
                                }, 0);
                                const fallbackPercentage = totalQuestions > 0 ? Math.round((localScore / totalQuestions) * 100) : 0;
                                const fallbackPass = fallbackPercentage >= 60;

                                score = Number(resultData?.score ?? localScore);
                                const calculatedTotal = Number(resultData?.totalQuestions ?? totalQuestions);
                                const percentage = Math.round(Number(resultData?.percentage ?? fallbackPercentage));
                                const pass = !!(resultData?.passed ?? fallbackPass);

                                setTimeout(() => {
                                    const resultMessage = pass ? '✓ You have passed this assessment!' : '✗ Try again to improve your score.';
                                    const resultHtml =
                                        '<div style="text-align: left; margin-top: 20px;">' +
                                        '  <p style="font-size: 18px; margin-bottom: 15px;">' +
                                        '    <strong>Score: ' + score + '/' + calculatedTotal + '</strong>' +
                                        '  </p>' +
                                        '  <p style="font-size: 16px; color: #666; margin-bottom: 15px;">' +
                                        '    Accuracy: <strong>' + percentage + '%</strong>' +
                                        '  </p>' +
                                        '  <p style="font-size: 14px; color: #888;">' +
                                        '    ' + resultMessage +
                                        '  </p>' +
                                        '</div>';

                                    Swal.fire({
                                        title: 'Assessment Complete! 🎉',
                                        html: resultHtml,
                                        icon: pass ? 'success' : 'warning',
                                        confirmButtonText: pass ? 'Continue to Next Phase' : 'Retake Assessment',
                                        cancelButtonText: 'Back to Course',
                                        showCancelButton: true,
                                        confirmButtonColor: '#4913ec',
                                        cancelButtonColor: '#6B7280'
                                    }).then((result) => {
                                        if (result.isConfirmed) {
                                            if (pass) {
                                                const nextPhaseId = Number(resultData?.nextPhaseId || 0);
                                                const enrollmentId = Number(resultData?.enrollmentId || activeEnrollmentId || 0);
                                                const pathId = Number(resultData?.pathId || 0);
                                                if (nextPhaseId > 0) {
                                                    let nextUrl = ctx + "/student/module?phaseId=" + nextPhaseId;
                                                    if (pathId > 0) {
                                                        nextUrl += "&path=" + pathId;
                                                    }
                                                    if (enrollmentId > 0) {
                                                        nextUrl += "&enrollmentId=" + enrollmentId;
                                                    }
                                                    window.location.href = nextUrl;
                                                } else if (enrollmentId > 0) {
                                                    window.location.href = ctx + "/student/progress?enrollmentId=" + enrollmentId;
                                                } else {
                                                    window.location.href = ctx + "/student/progress";
                                                }
                                            } else {
                                                // Reset quiz and start over
                                                currentIdx = 0;
                                                score = 0;
                                                userResponses = [];
                                                loadQuestion();
                                            }
                                        } else if (result.dismiss === Swal.DismissReason.cancel) {
                                            if (activeEnrollmentId > 0) {
                                                window.location.href = ctx + "/student/progress?enrollmentId=" + activeEnrollmentId;
                                            } else {
                                                history.back();
                                            }
                                        }
                                    });
                                }, 300);
                            }

                            function confirmExit() {
                                Swal.fire({
                                    title: 'Quit Assessment?',
                                    text: "Your progress in this test will be lost.",
                                    icon: 'question',
                                    showCancelButton: true,
                                    confirmButtonColor: '#ef4444',
                                    confirmButtonText: 'Yes, Quit'
                                    }).then((r) => {
                                        if (r.isConfirmed) {
                                            if (activeEnrollmentId > 0) {
                                                window.location.href = ctx + "/student/progress?enrollmentId=" + activeEnrollmentId;
                                            } else {
                                                history.back();
                                            }
                                        }
                                    });
                            }

                            document.addEventListener('DOMContentLoaded', function () {
                                document.getElementById('qCountDisplay').innerText = "Question 1 of " + totalQuestions;
                                loadQuestion();
                            });
                        </script>
                    </c:if>
                </c:if>

            </body>

            </html>