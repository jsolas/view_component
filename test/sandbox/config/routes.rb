# frozen_string_literal: true

Sandbox::Application.routes.draw do
  root to: "integration_examples#index"
  get :slots, to: "integration_examples#slots"
  get :empty_slot, to: "integration_examples#empty_slot"
  get :partial, to: "integration_examples#partial"
  get :content, to: "integration_examples#content"
  get :variants, to: "integration_examples#variants"
  get :products, to: "integration_examples#products"
  get :inline_products, to: "integration_examples#inline_products"
  get :cached, to: "integration_examples#cached"
  get :render_check, to: "integration_examples#render_check"
  get :controller_inline, to: "integration_examples#controller_inline"
  get :controller_inline_with_block, to: "integration_examples#controller_inline_with_block"
  get :controller_inline_baseline, to: "integration_examples#controller_inline_baseline"
  get :controller_to_string, to: "integration_examples#controller_to_string"
  get :controller_inline_baseline_with_layout, to: "integration_examples#controller_inline_baseline_with_layout"
  get :controller_to_string_with_layout, to: "integration_examples#controller_to_string_with_layout"
  get :layout_default, to: "layouts#default"
  get :layout_global_for_action, to: "layouts#global_for_action"
  get :layout_explicit_in_action, to: "layouts#explicit_in_action"
  get :layout_disabled_in_action, to: "layouts#disabled_in_action"
  get :layout_with_content_for, to: "layouts#with_content_for"
  get :nested_haml, to: "integration_examples#nested_haml"
  get :link_to_helper, to: "integration_examples#link_to_helper"
  get :cached_capture, to: "integration_examples#cached_capture"
  get :cached_partial, to: "integration_examples#cached_partial"
  get :inherited_sidecar, to: "integration_examples#inherited_sidecar"
  get :inherited_from_uncompilable_component, to: "integration_examples#inherited_from_uncompilable_component"
  get :unsafe_component, to: "integration_examples#unsafe_component"
  get :unsafe_preamble_component, to: "integration_examples#unsafe_preamble_component"
  get :unsafe_postamble_component, to: "integration_examples#unsafe_postamble_component"
  get :multiple_formats_component, to: "integration_examples#multiple_formats_component"
  get :slotable_default_override, to: "integration_examples#slotable_default_override"
  get :virtual_path_reset, to: "integration_examples#virtual_path_reset"
  post :create, to: "integration_examples#create"
  get :turbo_content_type, to: "integration_examples#turbo_content_type"
  post :submit, to: "integration_examples#submit"

  resources :posts

  constraints(lambda { |request| request.env["warden"].authenticate! }) do
    get :constraints_with_env, to: "integration_examples#index"
  end
  get :helpers_proxy_component, to: "integration_examples#helpers_proxy_component"
  get :turbo_stream, to: "integration_examples#turbo_stream"
end
