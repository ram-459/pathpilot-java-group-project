<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Certificate - ${path.title}</title>
    <script src="https://cdn.tailwindcss.com?plugins=forms"></script>
    <link href="https://fonts.googleapis.com/css2?family=Playfair+Display:wght@700;800;900&family=Plus+Jakarta+Sans:wght@300;400;500;600;700;800&family=Poppins:wght@600;700;800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>
    <script src="https://cdnjs.cloudflare.com/ajax/libs/html2pdf.js/0.10.1/html2pdf.bundle.min.js"></script>
    <style>
        body { font-family: 'Plus Jakarta Sans', sans-serif; }
        h1, h2, h3 { font-family: 'Poppins', sans-serif; }
        .cert-title { font-family: 'Playfair Display', serif; }
        
        @media print {
            * {
                margin: 0 !important;
                padding: 0 !important;
                border-collapse: collapse !important;
            }
            html, body {
                width: 100%;
                height: 100%;
                margin: 0;
                padding: 0;
            }
            .no-print { display: none !important; }
            .certificate-container { 
                box-shadow: none !important;
                page-break-after: avoid !important;
                page-break-before: avoid !important;
                page-break-inside: avoid !important;
                margin: 0 !important;
                padding: 0 !important;
            }
            body { background: white !important; }
            .flex, .grid, .container { 
                page-break-inside: avoid !important; 
            }
        }
    </style>
</head>
<body class="bg-gradient-to-br from-gray-50 to-gray-100 min-h-screen py-8">

<div class="flex items-center justify-center min-h-screen p-2">
    <div class="w-full">
        <!-- Header Controls -->
        <div class="no-print mb-6 flex items-center justify-between max-w-4xl mx-auto px-4 gap-3">
            <div>
                <h1 class="text-2xl font-bold text-gray-900">Your Certificate</h1>
                <p class="text-gray-500 text-sm mt-1">Recognition of your achievement</p>
            </div>
            <div class="flex gap-3">
                <button onclick="downloadCertificateAsPDF()" class="px-4 py-2 bg-indigo-600 text-white rounded-lg font-bold text-sm hover:bg-indigo-700 flex items-center gap-2 transition transform hover:scale-105">
                    <span class="material-icons-round text-sm">download</span>
                    Download
                </button>
                <button onclick="window.print()" class="px-4 py-2 bg-blue-600 text-white rounded-lg font-bold text-sm hover:bg-blue-700 flex items-center gap-2 transition transform hover:scale-105">
                    <span class="material-icons-round text-sm">print</span>
                    Print
                </button>
                <a href="<%=request.getContextPath()%>/student/career-paths" class="px-4 py-2 bg-gray-200 text-gray-700 rounded-lg font-bold text-sm hover:bg-gray-300 flex items-center gap-2 transition transform hover:scale-105">
                    <span class="material-icons-round text-sm">arrow_back</span>
                    Back
                </a>
            </div>
        </div>

        <!-- Main Certificate Container -->
        <div class="flex justify-center">
            <div class="certificate-container w-full max-w-5xl bg-white rounded-2xl shadow-2xl overflow-hidden border-8 border-double border-yellow-500" style="height: fit-content;">
                
                <!-- Certificate Header Gradient -->
                <div class="bg-gradient-to-r from-indigo-900 via-indigo-800 to-indigo-900 px-16 py-10 text-center relative overflow-hidden">
                    <!-- Decorative Background Pattern -->
                    <div class="absolute top-0 right-0 w-48 h-48 bg-white/5 rounded-full -mr-24 -mt-24"></div>
                    <div class="absolute bottom-0 left-0 w-40 h-40 bg-white/5 rounded-full -ml-20 -mb-20"></div>
                    
                    <div class="relative z-10">
                        <p class="text-yellow-300 text-xs font-black uppercase tracking-widest mb-2">PathPilot Learning Certificate</p>
                        <h2 class="text-4xl font-bold text-white cert-title">Certificate of Achievement</h2>
                    </div>
                </div>

                <!-- Certificate Body -->
                <div class="px-14 py-12 text-center">
                    <!-- Award Text -->
                    <p class="text-gray-600 text-base font-semibold mb-6">This certificate is proudly awarded to</p>
                    
                    <!-- Recipient Name -->
                    <div class="mb-10">
                        <p class="text-5xl font-bold text-indigo-900 cert-title border-b-4 border-yellow-400 pb-4 inline-block min-w-96">${userName}</p>
                        <p class="text-gray-500 text-xs mt-2">Recipient</p>
                    </div>

                    <!-- Achievement Text -->
                    <p class="text-gray-600 text-sm mb-6">for demonstrating exceptional commitment and successfully completing</p>
                    
                    <!-- Path Details -->
                    <div class="mb-12 p-6 bg-gradient-to-r from-indigo-50 to-blue-50 rounded-xl border-2 border-indigo-200">
                        <h3 class="text-2xl font-bold text-indigo-900 cert-title mb-2">${path.title}</h3>
                        <p class="text-gray-700 text-sm leading-snug mb-3">${path.description}</p>
                        <div class="flex justify-center gap-12 text-xs">
                            <div>
                                <p class="font-bold text-indigo-900">Level</p>
                                <p class="text-gray-600">${path.level}</p>
                            </div>
                            <div>
                                <p class="font-bold text-indigo-900">Status</p>
                                <p class="text-green-600 font-bold">✓ Completed</p>
                            </div>
                        </div>
                    </div>

                    <!-- Certificate Info Grid -->
                    <div class="grid grid-cols-3 gap-6 mb-12 text-center">
                        <div class="p-4 rounded-lg bg-gray-50 border border-gray-200">
                            <p class="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">Certificate ID</p>
                            <p class="text-lg font-mono font-bold text-indigo-900">${certificateId}</p>
                        </div>
                        <div class="p-4 rounded-lg bg-gray-50 border border-gray-200">
                            <p class="text-xs font-bold text-gray-500 uppercase tracking-widest mb-2">Issue Date</p>
                            <p class="text-base font-bold text-gray-800">
                                <% 
                                    java.time.LocalDateTime completionDate = (java.time.LocalDateTime) request.getAttribute("completionDate");
                                    java.time.format.DateTimeFormatter formatter = java.time.format.DateTimeFormatter.ofPattern("MMM dd, yyyy");
                                    if (completionDate != null) {
                                        out.print(completionDate.format(formatter));
                                    } else {
                                        out.print(java.time.LocalDate.now().format(formatter));
                                    }
                                %>
                            </p>
                        </div>
                        <div class="p-4 rounded-lg bg-green-50 border border-green-200">
                            <p class="text-xs font-bold text-green-600 uppercase tracking-widest mb-2">Status</p>
                            <p class="text-base font-bold text-green-700 flex items-center justify-center gap-1">
                                <span class="material-icons-round text-lg">verified</span>
                                Verified
                            </p>
                        </div>
                    </div>

                    <!-- Signature Section -->
                    <div class="border-t-4 border-gray-300 pt-8">
                        <div class="grid grid-cols-2 gap-8">
                            <div class="text-center">
                                <div class="h-12 mb-2 flex items-end justify-center">
                                    <p class="text-xs text-gray-400">_____________________</p>
                                </div>
                                <p class="font-bold text-gray-900 text-sm">PathPilot Administrator</p>
                                <p class="text-xs text-gray-600">Digital Signature</p>
                            </div>
                            <div class="text-center">
                                <div class="h-12 mb-2 flex items-center justify-center">
                                    <span class="material-icons-round text-4xl text-yellow-500">school</span>
                                </div>
                                <p class="font-bold text-gray-900 text-sm">PathPilot Institute</p>
                                <p class="text-xs text-gray-600">Certified Authority</p>
                            </div>
                        </div>
                    </div>
                </div>

                <!-- Certificate Footer -->
                <div class="bg-gradient-to-r from-gray-900 to-gray-800 px-14 py-4 text-center border-t-4 border-yellow-500">
                    <p class="text-gray-300 text-xs">PathPilot - Intelligent Learning Pathways | Empowering the Future</p>
                    <p class="text-gray-400 text-xs mt-1">🔒 This is an electronically issued certificate with full authenticity verification.</p>
                </div>
            </div>
        </div>

        <!-- Share Button -->
        <div class="no-print mt-6 flex justify-center">
            <button onclick="shareCertificate()" class="px-6 py-2 bg-green-500 text-white rounded-lg font-bold text-sm hover:bg-green-600 flex items-center gap-2 transition transform hover:scale-105">
                <span class="material-icons-round text-sm">share</span>
                Share Certificate
            </button>
        </div>
    </div>
</div>

<script>
    function downloadCertificateAsPDF() {
        const element = document.querySelector('.certificate-container');
        const opt = {
            margin: [3, 3, 3, 3],
            filename: 'PathPilot_Certificate_${certificateId}.pdf',
            image: { type: 'jpeg', quality: 0.95 },
            html2canvas: { scale: 2, useCORS: true, logging: false, backgroundColor: '#ffffff' },
            jsPDF: { orientation: 'landscape', unit: 'mm', format: 'a4', compress: true },
            pagebreak: { mode: 'avoid', before: '.certificate-container' }
        };
        
        html2pdf().set(opt).from(element).output('datauristring').then((pdfDataUri) => {
            // Force single page by setting page dimensions
            const pdf = html2pdf().set(opt);
            pdf.from(element).save();
        });
    }

    function shareCertificate() {
        const title = "${path.title}";
        const url = window.location.href;
        
        if (navigator.share) {
            navigator.share({
                title: 'I earned a certificate for: ' + title,
                text: 'I just completed the ' + title + ' learning path on PathPilot! 🎓',
                url: url
            });
        } else {
            const text = `I earned a certificate for: ${title}\nCheck it out: ${url}`;
            navigator.clipboard.writeText(text).then(() => {
                alert('Certificate link copied to clipboard!');
            });
        }
    }
</script>

</body>
</html>
