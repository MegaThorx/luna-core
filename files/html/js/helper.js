function openModal(name) {
  $(name).openModal({
      dismissible: false,
      opacity: 0.35,
      in_duration: 0,
      out_duration: 0
    });
}

function closeModal(name) {
   $(name).closeModal({
     out_duration: 0
   });
}
