(function() {
  function initParticles() {
    if (typeof particlesJS !== 'undefined' && document.getElementById('particles-js')) {
      particlesJS("particles-js", {
        particles: {
          number: { value: 140, density: { enable: true, value_area: 800 } },
          color: { value: "#CBE5C7" },
          shape: { type: "circle", stroke: { width: 0.5, color: "#F7E096" } },
          opacity: {
            value: 0.75,
            random: true,
            anim: { enable: true, speed: 1, opacity_min: 0.35 },
          },
          size: {
            value: 3,
            random: true,
            anim: { enable: true, speed: 2, size_min: 1 },
          },
          line_linked: {
            enable: true,
            distance: 160,
            color: "#BCE0B6",
            opacity: 0.48,
            width: 1.25,
          },
          move: { enable: true, speed: 2, random: true, out_mode: "bounce" },
        },
        interactivity: {
          detect_on: "window",
          events: {
            onhover: { enable: true, mode: "grab" },
            onclick: { enable: true, mode: "push" },
            resize: true,
          },
          modes: {
            grab: { distance: 220, line_linked: { opacity: 0.85 } },
            push: { particles_nb: 4 },
            repulse: { distance: 180, duration: 0.4 },
          },
        },
        retina_detect: true,
      });
    }
  }

  if (document.readyState === 'loading') {
    document.addEventListener('DOMContentLoaded', initParticles);
  } else {
    initParticles();
  }
})();
