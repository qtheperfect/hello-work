(* The Unique Complete Solution of andb_true_elim2 of LF *)
(* without using any contradictions or other advanced tactics *)

Lemma bcVerbose:
  forall b c : bool,
    andb b c = andb (andb b c) c.
Proof.
  intros [] [].
  - reflexivity.
  - reflexivity.
  - reflexivity.
  - reflexivity.
Qed.

Theorem andb_true_elim2 :
  forall b c : bool,
    andb b c = true -> c = true.
Proof.
  intros b c.
  intros H.
  (*  Target:  c = true *)
  rewrite <- H.
  (*   c = b && c *)
  rewrite bcVerbose.  
  (*   c = b && c && c *)
  rewrite H.
  (*   c = true && c *)
  simpl.
  (*   c = c *)
  reflexivity.
Qed.

