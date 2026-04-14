<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    if(session == null || session.getAttribute("role") == null){
        response.sendRedirect(request.getContextPath() + "/login");
        return;
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Zen - PathPilot</title>

    <script src="https://cdn.tailwindcss.com"></script>
    <link href="https://fonts.googleapis.com/css2?family=Plus+Jakarta+Sans:wght@600;800&family=Poppins:wght@800&display=swap" rel="stylesheet"/>
    <link href="https://fonts.googleapis.com/icon?family=Material+Icons+Round" rel="stylesheet"/>

    <script>
        tailwind.config = {
            theme: {
                extend: {
                    colors: { primary: "#4913ec" },
                    fontFamily: { 
                        sans: ["'Plus Jakarta Sans'", "sans-serif"], 
                        heading: ["Poppins", "sans-serif"] 
                    }
                }
            }
        }
    </script>

    <style type="text/tailwindcss">
        body { font-family: 'Plus Jakarta Sans', sans-serif; @apply bg-[#fdfdfd] antialiased; }
        .zen-card { background: rgba(255, 255, 255, 0.8); backdrop-filter: blur(8px); border: 1px solid rgba(0,0,0,0.03); transition: all 0.4s ease; }
        .main-content { @apply flex-1 flex items-center justify-center h-screen overflow-hidden p-12; }
        
        /* Heading Animation */
        .fade-in-up {
            animation: fadeInUp 0.8s ease-out forwards;
        }
        @keyframes fadeInUp {
            from { opacity: 0; transform: translateY(20px); }
            to { opacity: 1; transform: translateY(0); }
        }
    </style>
</head>

<body class="flex min-h-screen">

    <!-- 🧭 Sidebar Included -->
    <jsp:include page="/WEB-INF/views/components/user_sidebar.jsp" />

    <div class="main-content relative">
        
        <!-- 🎨 Ambient Background Blobs -->
        <div class="absolute top-0 left-0 w-96 h-96 bg-indigo-100/30 rounded-full blur-[120px] -z-10"></div>
        <div class="absolute bottom-0 right-0 w-96 h-96 bg-purple-100/20 rounded-full blur-[120px] -z-10"></div>

        <div class="w-[540px] flex flex-col items-center fade-in-up">
            
            <!-- ✨ Catchy Heading Section -->
            <div class="text-center mb-10">
                <div class="inline-flex items-center gap-2 px-3 py-1 bg-primary/5 rounded-full mb-4">
                    <span class="material-icons-round text-primary text-sm animate-pulse">auto_awesome</span>
                    <span class="text-[10px] font-black text-primary uppercase tracking-widest">Mindful Break</span>
                </div>
                <h1 class="text-4xl font-800 text-gray-900 tracking-tighter mb-2">
                    Daily <span class="text-primary">Dose of Wisdom</span>
                </h1>
                <p class="text-gray-400 text-sm font-medium">Recharge your mind with timeless epics & legends.</p>
            </div>
            
            <!-- 🃏 Zen Card -->
            <div id="quoteCard" class="zen-card w-full rounded-[3.5rem] p-12 shadow-2xl shadow-indigo-100/40 relative group overflow-hidden border border-white">
                <div class="relative z-10">
                    <span class="material-icons-round text-4xl text-primary/20 mb-8 block">format_quote</span>
                    
                    <p id="quoteText" class="text-xl font-semibold text-gray-800 leading-relaxed mb-12 min-h-[120px]">
                        Loading wisdom...
                    </p>
                    
                    <div class="flex items-center justify-between border-t border-gray-100 pt-8">
                        <div class="flex flex-col">
                            <h4 id="quoteAuthor" class="text-[12px] font-800 text-gray-900 uppercase tracking-wider">...</h4>
                            <span id="quoteTag" class="text-[10px] font-black text-primary bg-primary/5 px-3 py-1 rounded-md uppercase tracking-tighter mt-2 w-fit">...</span>
                        </div>
                        
                        <button onclick="updateZen()" class="w-14 h-14 bg-primary hover:bg-primary-dark text-white rounded-full flex items-center justify-center shadow-xl shadow-primary/30 transition-all active:scale-90 hover:rotate-45">
                            <span id="refreshIcon" class="material-icons-round text-xl">autorenew</span>
                        </button>
                    </div>
                </div>
            </div>

            <p class="mt-12 text-[10px] font-bold text-gray-300 uppercase tracking-[0.6em]">PathPilot Zen Protocol</p>
        </div>
    </div>

    <script>
        let zenDb = [];

        async function loadQuotes() {
            try {
                const response = await fetch('<%=request.getContextPath()%>/assets/json/wisdom.json');
                zenDb = await response.json();
                updateZen(); 
            } catch (error) {
                console.error("Failed to load wisdom JSON:", error);
                document.getElementById('quoteText').innerText = "Action is the foundational key to all success.";
                document.getElementById('quoteAuthor').innerText = "Pablo Picasso";
                document.getElementById('quoteTag').innerText = "Mindset";
            }
        }

        function updateZen() {
            if (zenDb.length === 0) return;

            const card = document.getElementById('quoteCard');
            const icon = document.getElementById('refreshIcon');
            
            icon.style.transform = "rotate(180deg)";
            card.style.opacity = "0.5";
            card.style.transform = "scale(0.97)";

            setTimeout(() => {
                const data = zenDb[Math.floor(Math.random() * zenDb.length)];
                
                document.getElementById('quoteText').innerText = data.text;
                document.getElementById('quoteAuthor').innerText = data.author;
                document.getElementById('quoteTag').innerText = data.tag;

                card.style.opacity = "1";
                card.style.transform = "scale(1)";
                icon.style.transform = "rotate(0deg)";
            }, 300);
        }

        window.onload = loadQuotes;
    </script>
</body>
</html>