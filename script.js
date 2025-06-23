// Actualizar el año en el footer
document.addEventListener("DOMContentLoaded", () => {
    // Funcionalidad original
    const currentYearElements = document.querySelectorAll("#current-year")
    const currentYear = new Date().getFullYear()
  
    currentYearElements.forEach((element) => {
      element.textContent = currentYear
    })

    // ===== NUEVAS FUNCIONES PARA AQUILES A1 REDISEÑADO =====

// Funcionalidad de video con scroll
document.addEventListener("DOMContentLoaded", () => {
  const scrollVideo = document.getElementById("scroll-video")
  const videoSection = document.querySelector(".video-scroll-section")
  const progressBar = document.querySelector(".progress-bar")
  const progressPercentage = document.getElementById("progress-percentage")
  const hotspots = document.querySelectorAll(".video-hotspot")

  if (scrollVideo && videoSection) {
    // Configurar el video
    scrollVideo.addEventListener("loadedmetadata", () => {
      console.log("Video cargado, duración:", scrollVideo.duration)
    })

    // Función para actualizar el video basado en el scroll
    function updateVideoOnScroll() {
      const rect = videoSection.getBoundingClientRect()
      const sectionHeight = videoSection.offsetHeight
      const windowHeight = window.innerHeight

      // Calcular el progreso del scroll dentro de la sección
      let scrollProgress = 0

      if (rect.top <= 0 && rect.bottom >= windowHeight) {
        // Estamos dentro de la sección
        scrollProgress = Math.abs(rect.top) / (sectionHeight - windowHeight)
        scrollProgress = Math.max(0, Math.min(1, scrollProgress))
      } else if (rect.bottom < windowHeight) {
        // Hemos pasado la sección
        scrollProgress = 1
      }

      // Actualizar el video
      if (scrollVideo.duration) {
        const targetTime = scrollProgress * scrollVideo.duration

        // Solo actualizar si hay una diferencia significativa
        if (Math.abs(scrollVideo.currentTime - targetTime) > 0.1) {
          scrollVideo.currentTime = targetTime
        }
      }

      // Actualizar la barra de progreso
      const percentage = Math.round(scrollProgress * 100)
      if (progressBar) {
        progressBar.style.setProperty("--progress", percentage + "%")
      }
      if (progressPercentage) {
        progressPercentage.textContent = percentage + "%"
      }

      // Actualizar hotspots
      updateHotspots(scrollProgress)
    }

    // Función para actualizar hotspots
    function updateHotspots(progress) {
      const progressPercent = progress * 100

      hotspots.forEach((hotspot) => {
        const trigger = Number.parseFloat(hotspot.getAttribute("data-trigger"))
        const tolerance = 5 // Tolerancia de 5%

        if (progressPercent >= trigger - tolerance && progressPercent <= trigger + tolerance + 10) {
          hotspot.classList.add("active")
        } else {
          hotspot.classList.remove("active")
        }
      })
    }

    // Event listener para scroll
    let ticking = false

    function onScroll() {
      if (!ticking) {
        requestAnimationFrame(() => {
          updateVideoOnScroll()
          ticking = false
        })
        ticking = true
      }
    }

    window.addEventListener("scroll", onScroll)

    // Llamar una vez al cargar
    updateVideoOnScroll()

    // Prevenir que el video se reproduzca automáticamente
    scrollVideo.addEventListener("play", (e) => {
      if (!scrollVideo.paused) {
        scrollVideo.pause()
      }
    })

    // Manejar errores de video
    scrollVideo.addEventListener("error", (e) => {
      console.error("Error al cargar el video:", e)
    })
  }

  // Animaciones de entrada para las nuevas secciones
  const observerOptions = {
    threshold: 0.1,
    rootMargin: "0px 0px -50px 0px",
  }

  const observer = new IntersectionObserver((entries) => {
    entries.forEach((entry) => {
      if (entry.isIntersecting) {
        entry.target.classList.add("animate-in")

        // Animación especial para las tarjetas de especificaciones
        if (entry.target.classList.contains("spec-category-new")) {
          const delay = Array.from(entry.target.parentNode.children).indexOf(entry.target) * 100
          setTimeout(() => {
            entry.target.style.transform = "translateY(0)"
            entry.target.style.opacity = "1"
          }, delay)
        }

        // Animación especial para las tarjetas de beneficios
        if (entry.target.classList.contains("benefit-card-new")) {
          const delay = Array.from(entry.target.parentNode.children).indexOf(entry.target) * 150
          setTimeout(() => {
            entry.target.style.transform = "translateY(0)"
            entry.target.style.opacity = "1"
          }, delay)
        }
      }
    })
  }, observerOptions)

  // Observar elementos para animaciones
  document.querySelectorAll(".spec-category-new, .benefit-card-new").forEach((el) => {
    el.style.transform = "translateY(50px)"
    el.style.opacity = "0"
    el.style.transition = "all 0.6s cubic-bezier(0.175, 0.885, 0.32, 1.275)"
    observer.observe(el)
  })

  // Efecto parallax para el hero
  const heroParticles = document.querySelector(".hero-particles")
  if (heroParticles) {
    window.addEventListener("scroll", () => {
      const scrolled = window.pageYOffset
      const rate = scrolled * -0.5
      heroParticles.style.transform = `translateY(${rate}px)`
    })
  }

  // Animación de typing para el título del hero
  const titleLines = document.querySelectorAll(".title-line")
  titleLines.forEach((line, index) => {
    const text = line.textContent
    line.textContent = ""

    setTimeout(
      () => {
        let i = 0
        const typeInterval = setInterval(() => {
          line.textContent += text.charAt(i)
          i++
          if (i >= text.length) {
            clearInterval(typeInterval)
          }
        }, 100)
      },
      index * 500 + 500,
    )
  })

  // Efecto de hover 3D para las tarjetas
  document.querySelectorAll(".spec-category-new, .benefit-card-new").forEach((card) => {
    card.addEventListener("mousemove", (e) => {
      const rect = card.getBoundingClientRect()
      const x = e.clientX - rect.left
      const y = e.clientY - rect.top

      const centerX = rect.width / 2
      const centerY = rect.height / 2

      const rotateX = ((y - centerY) / centerY) * -10
      const rotateY = ((x - centerX) / centerX) * 10

      card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) translateZ(10px)`
    })

    card.addEventListener("mouseleave", () => {
      card.style.transform = "perspective(1000px) rotateX(0deg) rotateY(0deg) translateZ(0px)"
    })
  })

  // Smooth scroll para los enlaces internos
  document.querySelectorAll('a[href^="#"]').forEach((anchor) => {
    anchor.addEventListener("click", function (e) {
      e.preventDefault()
      const target = document.querySelector(this.getAttribute("href"))
      if (target) {
        target.scrollIntoView({
          behavior: "smooth",
          block: "start",
        })
      }
    })
  })

  // Animación de partículas en el hero
  function createHeroParticles() {
    const heroBackground = document.querySelector(".hero-background")
    if (!heroBackground) return

    for (let i = 0; i < 50; i++) {
      const particle = document.createElement("div")
      particle.className = "floating-particle"
      particle.style.cssText = `
        position: absolute;
        width: ${Math.random() * 4 + 1}px;
        height: ${Math.random() * 4 + 1}px;
        background: rgba(140, 203, 213, ${Math.random() * 0.5 + 0.2});
        border-radius: 50%;
        top: ${Math.random() * 100}%;
        left: ${Math.random() * 100}%;
        animation: floatParticle ${Math.random() * 20 + 10}s linear infinite;
        animation-delay: ${Math.random() * 5}s;
      `
      heroBackground.appendChild(particle)
    }
  }

  // Agregar keyframes para las partículas flotantes
  const style = document.createElement("style")
  style.textContent = `
    @keyframes floatParticle {
      0% {
        transform: translateY(100vh) translateX(0);
        opacity: 0;
      }
      10% {
        opacity: 1;
      }
      90% {
        opacity: 1;
      }
      100% {
        transform: translateY(-100px) translateX(${Math.random() * 200 - 100}px);
        opacity: 0;
      }
    }
    
    .animate-in {
      animation: slideInUp 0.8s ease forwards;
    }
    
    @keyframes slideInUp {
      from {
        opacity: 0;
        transform: translateY(30px);
      }
      to {
        opacity: 1;
        transform: translateY(0);
      }
    }
  `
  document.head.appendChild(style)

  createHeroParticles()

  // Optimización de rendimiento para scroll
  let scrollTimeout
  window.addEventListener("scroll", () => {
    clearTimeout(scrollTimeout)
    scrollTimeout = setTimeout(() => {
      // Código que se ejecuta después de que el scroll se detiene
      document.body.classList.remove("scrolling")
    }, 150)

    document.body.classList.add("scrolling")
  })
})

// Función para manejar la carga del video
function handleVideoLoad() {
  const video = document.getElementById("scroll-video")
  if (video) {
    video.addEventListener("canplaythrough", () => {
      console.log("Video listo para reproducir")
      video.currentTime = 0
    })

    video.addEventListener("loadstart", () => {
      console.log("Iniciando carga del video")
    })

    video.addEventListener("progress", () => {
      if (video.buffered.length > 0) {
        const bufferedEnd = video.buffered.end(video.buffered.length - 1)
        const duration = video.duration
        if (duration > 0) {
          const bufferedPercent = (bufferedEnd / duration) * 100
          console.log(`Video cargado: ${bufferedPercent.toFixed(1)}%`)
        }
      }
    })
  }
}

// Llamar la función cuando el DOM esté listo
if (document.readyState === "loading") {
  document.addEventListener("DOMContentLoaded", handleVideoLoad)
} else {
  handleVideoLoad()
}

  
    // Menú móvil
    const mobileMenuBtn = document.querySelector(".mobile-menu-btn")
    const mobileMenu = document.querySelector(".mobile-menu")
  
    if (mobileMenuBtn && mobileMenu) {
      mobileMenuBtn.addEventListener("click", () => {
        mobileMenu.classList.toggle("active")
  
        // Cambiar el ícono del botón
        const icon = mobileMenuBtn.querySelector("i")
        if (mobileMenu.classList.contains("active")) {
          icon.classList.remove("fa-bars")
          icon.classList.add("fa-times")
        } else {
          icon.classList.remove("fa-times")
          icon.classList.add("fa-bars")
        }
      })
    }
  
    // Header con efecto de scroll
    const header = document.querySelector(".header")
  
    if (header) {
      window.addEventListener("scroll", () => {
        if (window.scrollY > 50) {
          header.classList.add("scrolled")
        } else {
          header.classList.remove("scrolled")
        }
      })
    }
  
    // Cerrar el menú móvil al hacer clic en un enlace
    const mobileMenuLinks = document.querySelectorAll(".mobile-menu a")
  
    mobileMenuLinks.forEach((link) => {
      link.addEventListener("click", () => {
        mobileMenu.classList.remove("active")
  
        const icon = mobileMenuBtn.querySelector("i")
        icon.classList.remove("fa-times")
        icon.classList.add("fa-bars")
      })
    })
  
    // Animación de entrada para elementos al hacer scroll
    const animateOnScroll = () => {
      const elements = document.querySelectorAll(".animate-on-scroll")
  
      elements.forEach((element) => {
        const elementPosition = element.getBoundingClientRect().top
        const screenPosition = window.innerHeight / 1.2
  
        if (elementPosition < screenPosition) {
          element.classList.add("animated")
        }
      })
    }
  
    // Aplicar clase para animación en scroll a elementos clave
    const applyAnimationClasses = () => {
      // Aplicar a elementos de la página principal
      document
        .querySelectorAll(
          ".feature-card, .service-card, .hero-text, .hero-image, .showcase-images, .showcase-text, .app-info, .app-mockup",
        )
        .forEach((el) => {
          el.classList.add("animate-on-scroll")
        })
  
      // Aplicar a elementos de otras páginas
      document
        .querySelectorAll(".about-card, .team-member, .gallery-item, .info-card, .values-card, .year-block, .cert-item")
        .forEach((el) => {
          el.classList.add("animate-on-scroll")
        })
    }
  
    applyAnimationClasses()
    animateOnScroll() // Ejecutar una vez al cargar
    window.addEventListener("scroll", animateOnScroll)
  
    // Contador animado para estadísticas
    const animateCounter = (element, target, duration) => {
      let start = 0
      const increment = target / (duration / 16)
  
      const updateCounter = () => {
        start += increment
        if (start < target) {
          element.textContent = Math.floor(start) + "%"
          requestAnimationFrame(updateCounter)
        } else {
          element.textContent = target + "%"
        }
      }
  
      updateCounter()
    }
  
    // Animar contadores cuando son visibles
    const animateCounters = () => {
      const counters = document.querySelectorAll(".stat-number")
  
      counters.forEach((counter) => {
        const elementPosition = counter.getBoundingClientRect().top
        const screenPosition = window.innerHeight / 1.2
  
        if (elementPosition < screenPosition && !counter.classList.contains("animated")) {
          counter.classList.add("animated")
          const target = Number.parseInt(counter.getAttribute("data-target"))
          animateCounter(counter, target, 2000)
        }
      })
    }
  
    window.addEventListener("scroll", animateCounters)
  
    // Crear partículas para el fondo
    const createParticles = () => {
      const heroSection = document.querySelector(".hero")
      if (heroSection && !document.getElementById("particles-js")) {
        const particlesContainer = document.createElement("div")
        particlesContainer.id = "particles-js"
        particlesContainer.style.position = "absolute"
        particlesContainer.style.top = "0"
        particlesContainer.style.left = "0"
        particlesContainer.style.width = "100%"
        particlesContainer.style.height = "100%"
        particlesContainer.style.zIndex = "1"
  
        heroSection.style.position = "relative"
        heroSection.style.overflow = "hidden"
  
        // Asegurarse de que el contenido esté por encima de las partículas
        const heroContainer = heroSection.querySelector(".container")
        if (heroContainer) {
          heroContainer.style.position = "relative"
          heroContainer.style.zIndex = "2"
        }
  
        heroSection.insertBefore(particlesContainer, heroSection.firstChild)
  
        // Cargar la librería particles.js si no está cargada
        if (typeof window.particlesJS === "undefined") {
          const script = document.createElement("script")
          script.src = "https://cdn.jsdelivr.net/particles.js/2.0.0/particles.min.js"
          script.onload = () => {
            initParticles()
          }
          document.head.appendChild(script)
        } else {
          initParticles()
        }
      }
    }
  
    const initParticles = () => {
      if (typeof window.particlesJS !== "undefined") {
        window.particlesJS("particles-js", {
          particles: {
            number: { value: 80, density: { enable: true, value_area: 800 } },
            color: { value: "#5cfffa" },
            shape: { type: "circle" },
            opacity: { value: 0.5, random: true },
            size: { value: 3, random: true },
            line_linked: {
              enable: true,
              distance: 150,
              color: "#5cfffa",
              opacity: 0.4,
              width: 1,
            },
            move: {
              enable: true,
              speed: 2,
              direction: "none",
              random: true,
              straight: false,
              out_mode: "out",
              bounce: false,
            },
          },
          interactivity: {
            detect_on: "canvas",
            events: {
              onhover: { enable: true, mode: "grab" },
              onclick: { enable: true, mode: "push" },
              resize: true,
            },
            modes: {
              grab: { distance: 140, line_linked: { opacity: 1 } },
              push: { particles_nb: 4 },
            },
          },
          retina_detect: true,
        })
      }
    }
  
    createParticles()
  
    // Crear partículas para la sección de la app
    const appParticles = document.getElementById("appParticles")
    if (appParticles) {
      // Crear partículas
      for (let i = 0; i < 50; i++) {
        const particle = document.createElement("div")
        particle.className = "particle"
        particle.style.position = "absolute"
        particle.style.width = Math.random() * 5 + "px"
        particle.style.height = particle.style.width
        particle.style.backgroundColor = "rgba(92, 255, 250, " + Math.random() * 0.3 + ")"
        particle.style.borderRadius = "50%"
        particle.style.top = Math.random() * 100 + "%"
        particle.style.left = Math.random() * 100 + "%"
        particle.style.animation = "float " + (Math.random() * 10 + 5) + "s linear infinite"
        particle.style.opacity = Math.random() * 0.5
  
        appParticles.appendChild(particle)
      }
    }
  
    // Crear líneas de circuito animadas
    const createCircuitLines = () => {
      const circuitContainers = document.querySelectorAll(".circuit-lines")
  
      circuitContainers.forEach((container) => {
        // Limpiar contenedor
        container.innerHTML = ""
  
        // Crear nuevas líneas
        for (let i = 0; i < 8; i++) {
          const line = document.createElement("div")
          line.className = "circuit-line"
  
          // Posición aleatoria
          line.style.top = Math.random() * 100 + "%"
          line.style.left = Math.random() * 50 + "%"
          line.style.width = Math.random() * 100 + 50 + "px"
  
          // Animación con retraso aleatorio
          line.style.animation = `glowPulse ${Math.random() * 2 + 2}s infinite alternate ${Math.random() * 2}s`
  
          container.appendChild(line)
        }
      })
    }
  
    createCircuitLines()
  
    // Efecto 3D para tarjetas
    const cards = document.querySelectorAll(".feature-card, .service-card")
  
    cards.forEach((card) => {
      card.addEventListener("mousemove", (e) => {
        const cardRect = card.getBoundingClientRect()
        const cardCenterX = cardRect.left + cardRect.width / 2
        const cardCenterY = cardRect.top + cardRect.height / 2
        const mouseX = e.clientX - cardCenterX
        const mouseY = e.clientY - cardCenterY
  
        // Calcular rotación basada en la posición del mouse
        const rotateX = (mouseY / (cardRect.height / 2)) * -5
        const rotateY = (mouseX / (cardRect.width / 2)) * 5
  
        card.style.transform = `perspective(1000px) rotateX(${rotateX}deg) rotateY(${rotateY}deg) scale(1.02)`
        card.style.transition = "transform 0.1s ease"
      })
  
      card.addEventListener("mouseleave", () => {
        card.style.transform = "perspective(1000px) rotateX(0) rotateY(0) scale(1)"
        card.style.transition = "transform 0.5s ease"
      })
    })
  
    // Efecto de typing para el título principal
    const heroTitle = document.querySelector(".hero-title span:first-child")
    if (heroTitle) {
      const text = heroTitle.textContent
      heroTitle.textContent = ""
      heroTitle.style.borderRight = "0.15em solid #5cfffa"
      heroTitle.style.animation = "blink-caret 0.75s step-end infinite"
  
      let i = 0
      const typeWriter = () => {
        if (i < text.length) {
          heroTitle.textContent += text.charAt(i)
          i++
          setTimeout(typeWriter, 100)
        } else {
          // Quitar el cursor después de terminar
          setTimeout(() => {
            heroTitle.style.borderRight = "none"
            heroTitle.style.animation = "none"
          }, 1500)
        }
      }
  
      setTimeout(typeWriter, 500)
    }
  })
  
  // Añadir keyframes para la animación de las partículas
  const style = document.createElement("style")
  style.innerHTML = `
  @keyframes float {
      0% {
          transform: translateY(0) translateX(0);
          opacity: 0;
      }
      50% {
          opacity: 0.5;
      }
      100% {
          transform: translateY(-100px) translateX(100px);
          opacity: 0;
      }
  }
  
  @keyframes blink-caret {
      from, to { border-color: transparent }
      50% { border-color: #5cfffa }
  }
  `
  
  document.head.appendChild(style)
  
  // Añadir al final del archivo script.js
  
  // Funcionalidad para los hotspots del exoesqueleto
  document.addEventListener("DOMContentLoaded", () => {
    // Inicializar el primer panel como activo
    document.getElementById("spec-ia").classList.add("active")
  
    // Manejar clics en los hotspots
    const hotspots = document.querySelectorAll(".hotspot")
    hotspots.forEach((hotspot) => {
      hotspot.addEventListener("click", function () {
        const feature = this.getAttribute("data-feature")
  
        // Ocultar todos los paneles
        document.querySelectorAll(".spec-panel").forEach((panel) => {
          panel.classList.remove("active")
        })
  
        // Mostrar el panel correspondiente
        document.getElementById(`spec-${feature}`).classList.add("active")
  
        // Efecto visual en el hotspot
        this.querySelector(".hotspot-ring").style.animation = "none"
        setTimeout(() => {
          this.querySelector(".hotspot-ring").style.animation = "pulse 2s infinite"
        }, 10)
      })
    })
  
    // Funcionalidad para las pestañas de especificaciones
    const specTabs = document.querySelectorAll(".spec-tab")
    specTabs.forEach((tab) => {
      tab.addEventListener("click", function () {
        const spec = this.getAttribute("data-spec")
  
        // Cambiar pestaña activa
        specTabs.forEach((t) => t.classList.remove("active"))
        this.classList.add("active")
  
        // Cambiar contenido activo
        document.querySelectorAll(".spec-content-panel").forEach((panel) => {
          panel.classList.remove("active")
        })
        document.getElementById(spec).classList.add("active")
      })
    })
  
    // Efecto de hover 3D para la imagen del exoesqueleto
    const exoContainer = document.querySelector(".exo-image-container")
    if (exoContainer) {
      exoContainer.addEventListener("mousemove", function (e) {
        const rect = this.getBoundingClientRect()
        const x = e.clientX - rect.left
        const y = e.clientY - rect.top
  
        const centerX = rect.width / 2
        const centerY = rect.height / 2
  
        const deltaX = (x - centerX) / centerX
        const deltaY = (y - centerY) / centerY
  
        const image = this.querySelector(".exo-main-image")
        if (image) {
          image.style.transform = `perspective(1000px) rotateY(${deltaX * 5}deg) rotateX(${-deltaY * 5}deg) scale(1.05)`
        }
      })
  
      exoContainer.addEventListener("mouseleave", function () {
        const image = this.querySelector(".exo-main-image")
        if (image) {
          image.style.transform = "perspective(1000px) rotateY(0deg) rotateX(0deg) scale(1)"
        }
      })
    }
  })


//Lightbox Function

function initLightbox() {
    const galleryItems = document.querySelectorAll('.gallery-image');
    const lightbox = document.createElement('div');
    lightbox.className = 'lightbox';
    lightbox.innerHTML = `
        <div class="lightbox-overlay"></div>
        <div class="lightbox-content">
            <img src="" alt="">
            <button class="lightbox-close">&times;</button>
            <button class="lightbox-prev">&lt;</button>
            <button class="lightbox-next">&gt;</button>
            <div class="lightbox-counter">1 / 1</div>
        </div>
    `;
    document.body.appendChild(lightbox);

    let currentIndex = 0;
    const images = Array.from(galleryItems).map(item => item.querySelector('img').src);

    galleryItems.forEach((item, index) => {
        item.addEventListener('click', () => {
            currentIndex = index;
            updateLightbox();
            lightbox.classList.add('active');
        });
    });

    function updateLightbox() {
        const lightboxImg = lightbox.querySelector('img');
        const counter = lightbox.querySelector('.lightbox-counter');
        lightboxImg.src = images[currentIndex];
        counter.textContent = `${currentIndex + 1} / ${images.length}`;
    }

    lightbox.querySelector('.lightbox-close').addEventListener('click', () => {
        lightbox.classList.remove('active');
    });

    lightbox.querySelector('.lightbox-prev').addEventListener('click', () => {
        currentIndex = (currentIndex - 1 + images.length) % images.length;
        updateLightbox();
    });

    lightbox.querySelector('.lightbox-next').addEventListener('click', () => {
        currentIndex = (currentIndex + 1) % images.length;
        updateLightbox();
    });

    // Close lightbox when clicking outside the image
    lightbox.addEventListener('click', (e) => {
        if (e.target === lightbox || e.target.classList.contains('lightbox-overlay')) {
            lightbox.classList.remove('active');
        }
    });

    // Keyboard navigation
    document.addEventListener('keydown', (e) => {
        if (!lightbox.classList.contains('active')) return;

        switch (e.key) {
            case 'Escape':
                lightbox.classList.remove('active');
                break;
            case 'ArrowLeft':
                currentIndex = (currentIndex - 1 + images.length) % images.length;
                updateLightbox();
                break;
            case 'ArrowRight':
                currentIndex = (currentIndex + 1) % images.length;
                updateLightbox();
                break;
        }
    });
}

// Initialize lightbox when DOM is loaded
document.addEventListener('DOMContentLoaded', initLightbox);

document.head.appendChild(style);
//   
// 
// 
// 
// 
// VOLVER (toggle image and label)
document.addEventListener('DOMContentLoaded', function() {
  var volverHotspot = document.getElementById('hotspot-volver');
  var exoImg = document.querySelector('.exo-main-image');
  var label = volverHotspot ? volverHotspot.querySelector('.hotspot-label') : null;

  // Paths (adjust if needed)
  var frontImg = "public/images/exoesqueleto-1.png";
  var backImg = "med/BACK.png";

  // Hotspot elements
  var hotspotIA = document.querySelector('.hotspot[data-feature="ia"]');
  var hotspotBateria = document.querySelector('.hotspot[data-feature="bateria"]');
  var hotspotSensor = document.querySelector('.hotspot[data-feature="sensor"]');
  var hotspotMotor = document.querySelector('.hotspot[data-feature="motor"]');
  var hotspotRegulador = document.querySelector('.hotspot[data-feature="regulador"]');


  // Define positions for each state
  var positionsFront = {
      ia:  { top: "25%", left: "75%" },
      bateria: { top: "45%", left: "80%" },
      sensor: { top: "66%", left: "60%"  },
      motor: { top: "42%", left: "77%" },
      regulador: { top: "74%", left: "43%" },
      volver: { top: "85%", left: "85%" }
  };
  var positionsBack = {
      ia:  { top: "20%", left: "22%" },
      bateria: { top: "35%", left: "38%" },
      sensor: { top: "60%", left: "20%" },
      motor: { top: "33%", left: "88%" },
      regulador: { top: "74", left: "52%" },
      volver: { top: "85%", left: "85%" }
  };

  function setHotspotPositions(positions) {
      if (hotspotIA) {
          hotspotIA.style.top = positions.ia.top;
          hotspotIA.style.left = positions.ia.left;
      }
      if (hotspotBateria) {
          hotspotBateria.style.top = positions.bateria.top;
          hotspotBateria.style.left = positions.bateria.left;
      }
      if (hotspotSensor) {
          hotspotSensor.style.top = positions.sensor.top;
          hotspotSensor.style.left = positions.sensor.left;
      }
      if (hotspotMotor) {
          hotspotMotor.style.top = positions.motor.top;
          hotspotMotor.style.left = positions.motor.left;
      }
      if (hotspotRegulador) {
        hotspotRegulador.style.top = positions.regulador.top;
        hotspotRegulador.style.left = positions.regulador.left;
      }
      if (volverHotspot) {
          volverHotspot.style.top = positions.volver.top;
          volverHotspot.style.left = positions.volver.left;
      }
  }

  // Helper to check which image is currently shown
  function isFront() {
      return exoImg.src.includes("exoesqueleto-1.png");
  }

  // Simple function to show/hide hotspots based on side
  function updateHotspotVisibility(side) {
      document.querySelectorAll('.hotspot').forEach(hotspot => {
          const hotspotSide = hotspot.getAttribute('data-side') || 'front';
          if (hotspotSide === side || hotspotSide === 'both') {
              hotspot.style.display = '';
          } else {
              hotspot.style.display = 'none';
          }
      });
  }

  if (volverHotspot && exoImg && label) {
      volverHotspot.addEventListener('click', function() {
          if (isFront()) {
              exoImg.src = backImg;
              setHotspotPositions(positionsBack);
              updateHotspotVisibility('back');
          } else {
              exoImg.src = frontImg;
              setHotspotPositions(positionsFront);
              updateHotspotVisibility('front');
          }
          label.innerHTML = '<i class="fas fa-arrow-left"></i> Dar la vuelta';

          // Open IA Adaptativa spec panel
          document.querySelectorAll('.spec-panel').forEach(function(panel) {
              panel.classList.remove('active');
          });
          var iaPanel = document.getElementById('spec-ia');
          if (iaPanel) iaPanel.classList.add('active');
      });

      // Set initial positions for front
      setHotspotPositions(positionsFront);
      updateHotspotVisibility('front');
  }
});

